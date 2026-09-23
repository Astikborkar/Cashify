from typing import Any, Dict, List, Optional
from pydantic import BaseModel, Field


# ==========================================
# Agent 1: Pricing AI Agent Schemas
# ==========================================
class DeviceVariantSpec(BaseModel):
    ram_gb: int
    storage_gb: int


class DeviceInput(BaseModel):
    brand: str
    model: str
    variant: DeviceVariantSpec
    purchase_year: int
    has_original_box: bool = True
    has_original_charger: bool = True
    has_valid_bill: bool = True


class ConditionInput(BaseModel):
    screen: str = Field("flawless", description="flawless, minor_scratches, cracked, dead_pixels")
    body: str = Field("flawless", description="flawless, minor_scratches, heavy_dents, bent")
    functional_issues: List[str] = Field(default_factory=list)


class DiagnosticTelemetry(BaseModel):
    touch_matrix_coverage: float = 1.0
    dead_pixels_detected: int = 0
    battery_health_percentage: int = 100
    camera_front_working: bool = True
    camera_rear_working: bool = True
    biometrics_working: bool = True
    speaker_mic_working: bool = True
    wifi_bluetooth_working: bool = True


class MarketContext(BaseModel):
    pincode: str = "560001"
    city: str = "Bengaluru"
    current_refurbished_mkt_avg: float = 35000.0


class PricingRequest(BaseModel):
    device: DeviceInput
    condition: ConditionInput
    diagnostic_telemetry: DiagnosticTelemetry
    market_context: MarketContext


class PriceAdjustmentItem(BaseModel):
    item: str
    adjustment: float


class PricingQuote(BaseModel):
    base_market_value: float
    final_offer_price: float
    price_breakdown: List[PriceAdjustmentItem]
    confidence_score: float
    price_lock_duration_days: int = 7
    pickup_priority: str = "EXPRESS_ELIGIBLE"


class PricingResponse(BaseModel):
    quote: PricingQuote


# ==========================================
# Agent 2: Diagnostics QC Agent Schemas
# ==========================================
class DiagnosticItemResult(BaseModel):
    test_id: str
    test_name: str
    passed: bool
    sensor_telemetry: Dict[str, Any] = Field(default_factory=dict)
    remarks: Optional[str] = None


class DiagnosticsEvaluationRequest(BaseModel):
    device_model: str
    imei: Optional[str] = None
    tests: List[DiagnosticItemResult]


class DiagnosticsEvaluationResponse(BaseModel):
    overall_health_score: int = Field(..., ge=0, le=100)
    hardware_grade: str  # EXCELLENT, GOOD, DEFECTIVE
    tests_passed: int
    tests_failed: int
    spoofing_detected: bool = False
    flagged_defects: List[str] = Field(default_factory=list)


# ==========================================
# Agent 3: Fraud Detection Shield Schemas
# ==========================================
class FraudCheckRequest(BaseModel):
    imei: str
    user_id: str
    client_ip: Optional[str] = None
    gps_lat: Optional[float] = None
    gps_lng: Optional[float] = None
    listing_velocity_48h: int = 1


class FraudCheckResponse(BaseModel):
    imei: str
    risk_score: int = Field(..., ge=0, le=100)
    risk_level: str  # LOW, MEDIUM, HIGH
    is_blacklisted_gsma: bool = False
    is_imei_duplicate: bool = False
    gps_spoofing_flag: bool = False
    action_decision: str  # AUTO_APPROVE, MANUAL_INSPECTION, FREEZE_AND_BLOCK
    explanation: str


# ==========================================
# Agent 4: Repair Cost Estimator Schemas
# ==========================================
class RepairEstimateRequest(BaseModel):
    brand: str
    model: str
    issues: List[str]  # e.g., ["screen_glass", "battery", "camera"]


class RepairCostBreakdownItem(BaseModel):
    issue_name: str
    part_cost: float
    labor_cost: float
    warranty_months: int = 6


class RepairEstimateResponse(BaseModel):
    device: str
    items: List[RepairCostBreakdownItem]
    subtotal: float
    combo_discount: float
    final_total: float
    estimated_time_minutes: int
    parts_guarantee: str = "OEM Grade Certified 6-Month Warranty"


# ==========================================
# Agent 5: Recommendation Agent Schemas
# ==========================================
class RecommendationRequest(BaseModel):
    query: str
    max_budget: Optional[float] = None
    preferred_brands: List[str] = Field(default_factory=list)
    trade_in_device: Optional[str] = None
    trade_in_estimated_value: Optional[float] = None


class RecommendedProduct(BaseModel):
    product_id: str
    title: str
    grade: str
    price: float
    effective_trade_in_price: Optional[float] = None
    highlight_reason: str


class RecommendationResponse(BaseModel):
    user_intent: str
    recommendations: List[RecommendedProduct]


# ==========================================
# Agent 6: Support Chatbot Agent Schemas
# ==========================================
class SupportChatRequest(BaseModel):
    user_id: str
    message: str
    active_order_id: Optional[str] = None


class SupportChatResponse(BaseModel):
    reply: str
    sender_type: str = "ai_bot"  # ai_bot, human_agent
    quick_suggestions: List[str] = Field(default_factory=list)
    escalate_to_human: bool = False
    intent_detected: str


# ==========================================
# Agent 7: Notification Omnichannel Schemas
# ==========================================
class NotificationDispatchRequest(BaseModel):
    event_type: str  # PRICE_DROP, PICKUP_ASSIGNED, ABANDONED_SELL, PAYOUT_SUCCESS
    user_id: str
    phone: str
    data: Dict[str, Any]


class NotificationDispatchResponse(BaseModel):
    channel_used: str  # PUSH, WHATSAPP, SMS
    delivery_status: str
    message_dispatched: str
