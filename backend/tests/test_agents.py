import pytest
from app.agents.diagnostics_agent import diagnostics_agent
from app.agents.fraud_agent import fraud_agent
from app.agents.notification_agent import notification_agent
from app.agents.pricing_agent import pricing_agent
from app.agents.recommendation_agent import recommendation_agent
from app.agents.repair_agent import repair_cost_agent
from app.agents.supervisor import supervisor_agent
from app.agents.support_agent import support_agent
from app.schemas.agents import (
    ConditionInput,
    DeviceInput,
    DeviceVariantSpec,
    DiagnosticItemResult,
    DiagnosticsEvaluationRequest,
    DiagnosticTelemetry,
    FraudCheckRequest,
    MarketContext,
    NotificationDispatchRequest,
    PricingRequest,
    RecommendationRequest,
    RepairEstimateRequest,
    SupportChatRequest,
)


def test_pricing_agent_valuation_deductions():
    req = PricingRequest(
        device=DeviceInput(
            brand="Apple",
            model="iPhone 13",
            variant=DeviceVariantSpec(ram_gb=4, storage_gb=128),
            purchase_year=2022,
            has_original_box=True,
            has_original_charger=True,
            has_valid_bill=True,
        ),
        condition=ConditionInput(
            screen="minor_scratches",
            body="flawless",
            functional_issues=[],
        ),
        diagnostic_telemetry=DiagnosticTelemetry(
            touch_matrix_coverage=1.0,
            dead_pixels_detected=0,
            battery_health_percentage=78,
            camera_front_working=True,
            camera_rear_working=True,
            biometrics_working=True,
        ),
        market_context=MarketContext(
            pincode="560001",
            city="Bengaluru",
            current_refurbished_mkt_avg=35000.0,
        ),
    )

    resp = pricing_agent.calculate_quote(req)
    assert resp.quote.base_market_value == 35000.0
    assert resp.quote.final_offer_price > 1000.0
    assert resp.quote.confidence_score >= 0.90
    assert len(resp.quote.price_breakdown) >= 4


def test_diagnostics_agent_spoofing_detection():
    req = DiagnosticsEvaluationRequest(
        device_model="Apple iPhone 13",
        tests=[
            DiagnosticItemResult(
                test_id="touch_screen",
                test_name="Touch Screen Matrix",
                passed=True,
                sensor_telemetry={"matrix_coverage": 1.0},
            ),
            DiagnosticItemResult(
                test_id="gyroscope",
                test_name="Gyroscope 3-Axis",
                passed=True,
                sensor_telemetry={"delta_rad_s": 0.0},  # Flatline -> Spoofing
            ),
        ],
    )

    resp = diagnostics_agent.evaluate_telemetry(req)
    assert resp.spoofing_detected is True


def test_fraud_agent_blacklisted_gsma():
    req = FraudCheckRequest(
        imei="358912093819283",  # Known blacklisted IMEI
        user_id="usr-test",
    )
    resp = fraud_agent.inspect_device_risk(req)
    assert resp.risk_score >= 80
    assert resp.risk_level == "HIGH"
    assert resp.action_decision == "FREEZE_AND_BLOCK"


def test_repair_cost_combo_discount():
    req = RepairEstimateRequest(
        brand="Apple",
        model="iPhone 13",
        issues=["screen_glass", "battery"],
    )
    resp = repair_cost_agent.estimate_repair(req)
    assert len(resp.items) == 2
    assert resp.combo_discount > 0.0  # 15% discount on labor
    assert resp.final_total < resp.subtotal


def test_recommendation_trade_in_effective_price():
    req = RecommendationRequest(
        query="Upgrade my iPhone",
        trade_in_device="iPhone 11",
        trade_in_estimated_value=15000.0,
    )
    resp = recommendation_agent.recommend(req)
    assert len(resp.recommendations) > 0
    top = resp.recommendations[0]
    assert top.effective_trade_in_price is not None
    assert top.effective_trade_in_price == top.price - 15000.0


def test_customer_support_human_escalation():
    req = SupportChatRequest(
        user_id="usr-test",
        message="I want to speak with a human agent immediately, this is urgent",
    )
    resp = support_agent.process_message(req)
    assert resp.escalate_to_human is True
    assert resp.sender_type == "human_agent"


def test_notification_omnichannel_routing():
    req = NotificationDispatchRequest(
        event_type="PRICE_DROP",
        user_id="usr-test",
        phone="+919876543210",
        data={"drop_amount": "₹3,500", "product_title": "iPhone 13"},
    )
    resp = notification_agent.dispatch(req)
    assert resp.channel_used == "PUSH"
    assert "₹3,500" in resp.message_dispatched


def test_supervisor_orchestration_blocking_stolen_imei():
    req = PricingRequest(
        device=DeviceInput(
            brand="Apple",
            model="iPhone 13",
            variant=DeviceVariantSpec(ram_gb=4, storage_gb=128),
            purchase_year=2022,
        ),
        condition=ConditionInput(),
        diagnostic_telemetry=DiagnosticTelemetry(),
        market_context=MarketContext(),
    )
    result = supervisor_agent.handle_valuation_with_guardrails(
        req=req,
        imei="358912093819283",  # Stolen IMEI
        user_id="usr-test",
    )
    assert result["status"] == "BLOCKED"
    assert result["quote"] is None
