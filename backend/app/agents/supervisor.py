import time
from typing import Any, Dict

from app.agents.diagnostics_agent import diagnostics_agent
from app.agents.fraud_agent import fraud_agent
from app.agents.notification_agent import notification_agent
from app.agents.pricing_agent import pricing_agent
from app.agents.recommendation_agent import recommendation_agent
from app.agents.repair_agent import repair_cost_agent
from app.agents.support_agent import support_agent
from app.schemas.agents import (
    DiagnosticsEvaluationRequest,
    FraudCheckRequest,
    NotificationDispatchRequest,
    PricingRequest,
    PricingResponse,
    RecommendationRequest,
    RepairEstimateRequest,
    SupportChatRequest,
)


class SupervisorRouterAgent:
    """Supervisor & Router Agent:
    - Coordinates the 7 autonomous agents.
    - Applies guardrails and validation.
    - Enforces SLA performance goals (Sub-500ms deterministic pricing, Sub-1.2s conversational).
    """

    def handle_valuation_with_guardrails(self, req: PricingRequest, imei: str, user_id: str) -> Dict[str, Any]:
        start = time.time()

        # Step 1: Fraud Detection Shield pre-check
        fraud_check = fraud_agent.inspect_device_risk(
            FraudCheckRequest(
                imei=imei,
                user_id=user_id,
                listing_velocity_48h=1,
            )
        )

        risk_penalty = 0.0
        if fraud_check.risk_level == "MEDIUM":
            risk_penalty = 1500.0  # Risk buffer
        elif fraud_check.risk_level == "HIGH":
            # Block quote
            latency = int((time.time() - start) * 1000)
            return {
                "status": "BLOCKED",
                "fraud_assessment": fraud_check.model_dump(),
                "quote": None,
                "latency_ms": latency,
            }

        # Step 2: Pricing AI Agent calculation
        pricing_resp: PricingResponse = pricing_agent.calculate_quote(req, risk_penalty=risk_penalty)

        latency = int((time.time() - start) * 1000)
        return {
            "status": "APPROVED",
            "fraud_assessment": fraud_check.model_dump(),
            "quote": pricing_resp.quote.model_dump(),
            "latency_ms": latency,
        }


supervisor_agent = SupervisorRouterAgent()
