import uuid
from typing import List, Optional
from sqlalchemy import Boolean, ForeignKey, Numeric, String, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base
from app.models.base import TimestampMixin


class Category(Base, TimestampMixin):
    __tablename__ = "categories"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name: Mapped[str] = mapped_column(String(100), unique=True, nullable=False)
    slug: Mapped[str] = mapped_column(String(100), unique=True, nullable=False)
    icon_url: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)

    brands: Mapped[List["Brand"]] = relationship("Brand", back_populates="category", cascade="all, delete-orphan")


class Brand(Base, TimestampMixin):
    __tablename__ = "brands"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    category_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("categories.id", ondelete="CASCADE"), nullable=False)
    name: Mapped[str] = mapped_column(String(100), nullable=False)
    slug: Mapped[str] = mapped_column(String(100), nullable=False)
    logo_url: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    is_popular: Mapped[bool] = mapped_column(Boolean, default=False)

    category: Mapped["Category"] = relationship("Category", back_populates="brands")
    models: Mapped[List["DeviceModel"]] = relationship("DeviceModel", back_populates="brand", cascade="all, delete-orphan")


class DeviceModel(Base, TimestampMixin):
    __tablename__ = "device_models"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    brand_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("brands.id", ondelete="CASCADE"), nullable=False)
    name: Mapped[str] = mapped_column(String(150), nullable=False)
    slug: Mapped[str] = mapped_column(String(150), nullable=False)
    image_url: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    release_year: Mapped[int] = mapped_column(default=2022)
    base_mrp: Mapped[float] = mapped_column(Numeric(10, 2), default=0.0)

    brand: Mapped["Brand"] = relationship("Brand", back_populates="models")
    variants: Mapped[List["DeviceVariant"]] = relationship("DeviceVariant", back_populates="device_model", cascade="all, delete-orphan")


class DeviceVariant(Base, TimestampMixin):
    __tablename__ = "device_variants"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    device_model_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("device_models.id", ondelete="CASCADE"), nullable=False)
    ram_gb: Mapped[int] = mapped_column(default=4)
    storage_gb: Mapped[int] = mapped_column(default=64)
    color: Mapped[Optional[str]] = mapped_column(String(50), nullable=True)
    max_quote_price: Mapped[float] = mapped_column(Numeric(10, 2), nullable=False)

    device_model: Mapped["DeviceModel"] = relationship("DeviceModel", back_populates="variants")
