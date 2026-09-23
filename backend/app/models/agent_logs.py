import uuid
from typing import Optional
from sqlalchemy import ForeignKey, Numeric, String, Text
from sqlalchemy.dialects.postgresql import JSONB, UUID
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import Base
from app.models.base import TimestampMixin


class AIAgentLog(Base, TimestampMixin):
    __tablename__ = "ai_agent_logs"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    agent_name: Mapped[str] = mapped_column(String(50), index=True, nullable=False)
    user_id: Mapped[Optional[uuid.UUID]] = mapped_column(UUID(as_uuid=True), nullable=True)
    input_payload: Mapped[dict] = mapped_column(JSONB, nullable=False)
    output_response: Mapped[dict] = mapped_column(JSONB, nullable=False)
    latency_ms: Mapped[int] = mapped_column(nullable=False)
    confidence_score: Mapped[Optional[float]] = mapped_column(Numeric(3, 2), nullable=True)


class FraudCheck(Base, TimestampMixin):
    __tablename__ = "fraud_checks"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    imei: Mapped[str] = mapped_column(String(20), index=True, nullable=False)
    risk_score: Mapped[int] = mapped_column(nullable=False)
    risk_level: Mapped[str] = mapped_column(String(20), nullable=False)  # LOW, MEDIUM, HIGH
    flags: Mapped[list] = mapped_column(JSONB, default=list)
    action_taken: Mapped[str] = mapped_column(String(50), nullable=False)
