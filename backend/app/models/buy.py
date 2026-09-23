import uuid
from typing import List, Optional
from sqlalchemy import Boolean, ForeignKey, Integer, Numeric, String, Text
from sqlalchemy.dialects.postgresql import JSONB, UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base
from app.models.base import TimestampMixin


class RefurbishedProduct(Base, TimestampMixin):
    __tablename__ = "refurbished_products"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    title: Mapped[str] = mapped_column(String(200), nullable=False)
    brand: Mapped[str] = mapped_column(String(100), nullable=False)
    grade: Mapped[str] = mapped_column(String(20), default="SUPERB")  # SUPERB, GOOD, FAIR
    ram_gb: Mapped[int] = mapped_column(Integer, default=6)
    storage_gb: Mapped[int] = mapped_column(Integer, default=128)
    color: Mapped[str] = mapped_column(String(50), default="Black")
    original_price: Mapped[float] = mapped_column(Numeric(10, 2), nullable=False)
    sale_price: Mapped[float] = mapped_column(Numeric(10, 2), nullable=False)
    discount_percentage: Mapped[int] = mapped_column(Integer, default=20)
    rating: Mapped[float] = mapped_column(Numeric(2, 1), default=4.8)
    review_count: Mapped[int] = mapped_column(Integer, default=120)
    warranty_months: Mapped[int] = mapped_column(Integer, default=12)
    stock_quantity: Mapped[int] = mapped_column(Integer, default=5)
    image_urls: Mapped[list] = mapped_column(JSONB, default=list)
    specs: Mapped[dict] = mapped_column(JSONB, default=dict)
    is_in_stock: Mapped[bool] = mapped_column(Boolean, default=True)


class BuyOrder(Base, TimestampMixin):
    __tablename__ = "buy_orders"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    order_code: Mapped[str] = mapped_column(String(30), unique=True, index=True, nullable=False)
    user_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)
    total_amount: Mapped[float] = mapped_column(Numeric(10, 2), nullable=False)
    coupon_discount: Mapped[float] = mapped_column(Numeric(10, 2), default=0.0)
    delivery_fee: Mapped[float] = mapped_column(Numeric(10, 2), default=0.0)
    payment_method: Mapped[str] = mapped_column(String(30), default="ONLINE")
    payment_status: Mapped[str] = mapped_column(String(30), default="PAID")
    order_status: Mapped[str] = mapped_column(String(30), default="CONFIRMED")
    shipping_address: Mapped[str] = mapped_column(Text, nullable=False)
    items: Mapped[list] = mapped_column(JSONB, default=list)
