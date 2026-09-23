import uuid
from typing import Optional
from sqlalchemy import Boolean, ForeignKey, Integer, Numeric, String, Text
from sqlalchemy.dialects.postgresql import JSONB, UUID
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import Base
from app.models.base import TimestampMixin


class RepairIssue(Base, TimestampMixin):
    __tablename__ = "repair_issues"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    code: Mapped[str] = mapped_column(String(50), unique=True, nullable=False)
    title: Mapped[str] = mapped_column(String(100), nullable=False)
    description: Mapped[str] = mapped_column(Text, nullable=False)
    price: Mapped[float] = mapped_column(Numeric(10, 2), nullable=False)
    original_price: Mapped[float] = mapped_column(Numeric(10, 2), nullable=False)
    turnaround_minutes: Mapped[int] = mapped_column(Integer, default=30)
    warranty_months: Mapped[int] = mapped_column(Integer, default=6)
    is_popular: Mapped[bool] = mapped_column(Boolean, default=False)


class Technician(Base, TimestampMixin):
    __tablename__ = "technicians"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name: Mapped[str] = mapped_column(String(100), nullable=False)
    phone: Mapped[str] = mapped_column(String(20), nullable=False)
    rating: Mapped[float] = mapped_column(Numeric(2, 1), default=4.9)
    repairs_completed: Mapped[int] = mapped_column(Integer, default=120)
    current_lat: Mapped[float] = mapped_column(Numeric(9, 6), default=12.9716)
    current_lng: Mapped[float] = mapped_column(Numeric(9, 6), default=77.5946)
    is_available: Mapped[bool] = mapped_column(Boolean, default=True)


class RepairOrder(Base, TimestampMixin):
    __tablename__ = "repair_orders"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    order_code: Mapped[str] = mapped_column(String(30), unique=True, index=True, nullable=False)
    user_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)
    technician_id: Mapped[Optional[uuid.UUID]] = mapped_column(UUID(as_uuid=True), ForeignKey("technicians.id"), nullable=True)
    device_model: Mapped[str] = mapped_column(String(100), nullable=False)
    selected_issues: Mapped[list] = mapped_column(JSONB, default=list)
    total_amount: Mapped[float] = mapped_column(Numeric(10, 2), nullable=False)
    bundle_discount: Mapped[float] = mapped_column(Numeric(10, 2), default=0.0)
    status: Mapped[str] = mapped_column(String(30), default="TECHNICIAN_ASSIGNED")
    scheduled_date: Mapped[str] = mapped_column(String(20), nullable=False)
    scheduled_slot: Mapped[str] = mapped_column(String(50), nullable=False)
    service_address: Mapped[str] = mapped_column(Text, nullable=False)
    service_otp: Mapped[str] = mapped_column(String(6), nullable=False)
