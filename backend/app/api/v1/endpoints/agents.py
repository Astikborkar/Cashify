import time
from fastapi import APIRouter
from app.agents.diagnostics_agent import diagnostics_agent
from app.agents.fraud_agent import fraud_agent
from app.agents.notification_agent import notification_agent
from app.agents.pricing_agent import pricing_agent
from app.agents.recommendation_agent import recommendation_agent
from app.agents.repair_agent import repair_cost_agent
from app.agents.supervisor import supervisor_agent
from app.agents.support_agent import support_agent
from app.schemas.agents import (
    DiagnosticsEvaluationRequest,
    DiagnosticsEvaluationResponse,
    FraudCheckRequest,
    FraudCheckResponse,
    NotificationDispatchRequest,
    NotificationDispatchResponse,
    PricingRequest,
    PricingResponse,
    RecommendationRequest,
    RecommendationResponse,
    RepairEstimateRequest,
    RepairEstimateResponse,
    SupportChatRequest,
    SupportChatResponse,
)

router = APIRouter()


@router.post("/pricing/quote", response_model=PricingResponse)
async def get_pricing_quote(req: PricingRequest):
    """Agent 1: Predicts dynamic fair market valuation with depreciation & telemetry deductions."""
    return pricing_agent.calculate_quote(req)


@router.post("/diagnostics/evaluate", response_model=DiagnosticsEvaluationResponse)
async def evaluate_diagnostics(req: DiagnosticsEvaluationRequest):
    """Agent 2: Evaluates 16 hardware test results, detects sensor spoofing, outputs Device Health Score."""
    return diagnostics_agent.evaluate_telemetry(req)


@router.post("/fraud/inspect", response_model=FraudCheckResponse)
async def inspect_fraud_risk(req: FraudCheckRequest):
    """Agent 3: Screen against GSMA stolen registry, duplicate IMEIs, and mock GPS spoofing."""
    return fraud_agent.inspect_device_risk(req)


@router.post("/repair/estimate", response_model=RepairEstimateResponse)
async def estimate_repair_cost(req: RepairEstimateRequest):
    """Agent 4: Calculates OEM parts + labor and applies 15% combo bundle discount."""
    return repair_cost_agent.estimate_repair(req)


@router.post("/recommendations", response_model=RecommendationResponse)
async def get_recommendations(req: RecommendationRequest):
    """Agent 5: Natural language intent matchmaker and trade-in upgrade calculator."""
    return recommendation_agent.recommend(req)


@router.post("/support/chat", response_model=SupportChatResponse)
async def support_chat(req: SupportChatRequest):
    """Agent 6: Autonomous customer support assistant with order tracking and human escalation."""
    return support_agent.process_message(req)


@router.post("/notifications/dispatch", response_model=NotificationDispatchResponse)
async def dispatch_notification(req: NotificationDispatchRequest):
    """Agent 7: Omnichannel marketing & alerts dispatch (Push, SMS, WhatsApp)."""
    return notification_agent.dispatch(req)


@router.post("/supervisor/orchestrate")
async def supervisor_orchestration(req: PricingRequest, imei: str = "358912093819283", user_id: str = "usr-88192"):
    """Supervisor & Router Agent orchestrating fraud check and pricing with SLA enforcement."""
    return supervisor_agent.handle_valuation_with_guardrails(req, imei=imei, user_id=user_id)
