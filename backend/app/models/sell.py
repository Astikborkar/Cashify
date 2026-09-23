import uuid
from typing import Optional
from sqlalchemy import Boolean, DateTime, ForeignKey, Numeric, String, Text
from sqlalchemy.dialects.postgresql import JSONB, UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base
from app.models.base import TimestampMixin


class SellOrder(Base, TimestampMixin):
    __tablename__ = "sell_orders"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    order_code: Mapped[str] = mapped_column(String(30), unique=True, index=True, nullable=False)
    user_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="RESTRICT"), nullable=False)
    variant_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("device_variants.id"), nullable=False)
    
    # Valuation details
    base_price: Mapped[float] = mapped_column(Numeric(10, 2), nullable=False)
    final_offered_price: Mapped[float] = mapped_column(Numeric(10, 2), nullable=False)
    price_breakdown: Mapped[dict] = mapped_column(JSONB, default=dict)
    
    # Status
    status: Mapped[str] = mapped_column(String(30), default="QUOTE_GENERATED")
    # QUOTE_GENERATED, PICKUP_SCHEDULED, TECHNICIAN_ASSIGNED, EVALUATION_COMPLETE, PAID_OUT, CANCELLED
    
    # Pickup details
    pickup_address: Mapped[str] = mapped_column(Text, nullable=False)
    pickup_date: Mapped[str] = mapped_column(String(20), nullable=False)
    pickup_slot: Mapped[str] = mapped_column(String(50), nullable=False)
    handover_otp: Mapped[str] = mapped_column(String(6), nullable=False)
    
    # Verification & Telemetry
    imei_number: Mapped[Optional[str]] = mapped_column(String(20), nullable=True)
    diagnostic_report_id: Mapped[Optional[uuid.UUID]] = mapped_column(UUID(as_uuid=True), nullable=True)
    fraud_risk_score: Mapped[int] = mapped_column(default=0)
