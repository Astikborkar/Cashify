import uuid
from typing import List, Optional
from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter()

MOCK_REFURBISHED = [
    {
        "id": "prod-1",
        "title": "Apple iPhone 13 (128GB - Midnight)",
        "brand": "Apple",
        "grade": "SUPERB",
        "ram_gb": 4,
        "storage_gb": 128,
        "color": "Midnight",
        "original_price": 59900.0,
        "sale_price": 38999.0,
        "discount_percentage": 35,
        "rating": 4.8,
        "review_count": 340,
        "warranty_months": 12,
        "in_stock": True,
        "images": ["assets/images/placeholder_phone.png"],
    },
    {
        "id": "prod-2",
        "title": "Samsung Galaxy S22 5G (128GB - Phantom Black)",
        "brand": "Samsung",
        "grade": "SUPERB",
        "ram_gb": 8,
        "storage_gb": 128,
        "color": "Phantom Black",
        "original_price": 72999.0,
        "sale_price": 29999.0,
        "discount_percentage": 58,
        "rating": 4.6,
        "review_count": 180,
        "warranty_months": 12,
        "in_stock": True,
        "images": ["assets/images/placeholder_phone.png"],
    },
    {
        "id": "prod-3",
        "title": "Apple MacBook Air M1 (256GB - Space Grey)",
        "brand": "Apple",
        "grade": "SUPERB",
        "ram_gb": 8,
        "storage_gb": 256,
        "color": "Space Grey",
        "original_price": 99900.0,
        "sale_price": 54999.0,
        "discount_percentage": 44,
        "rating": 4.9,
        "review_count": 520,
        "warranty_months": 12,
        "in_stock": True,
        "images": ["assets/images/placeholder_phone.png"],
    },
]


class CheckoutRequest(BaseModel):
    items: List[dict]
    total_amount: float
    shipping_address: str
    coupon_code: Optional[str] = None


@router.get("/products")
async def list_refurbished_products():
    return MOCK_REFURBISHED


@router.get("/products/{product_id}")
async def get_refurbished_product_details(product_id: str):
    for p in MOCK_REFURBISHED:
        if p["id"] == product_id:
            return p
    return MOCK_REFURBISHED[0]


@router.post("/checkout")
async def checkout_order(payload: CheckoutRequest):
    order_code = f"BO-{str(uuid.uuid4().int)[:5]}"
    return {
        "status": "CONFIRMED",
        "order_code": order_code,
        "total_amount": payload.total_amount,
        "shipping_address": payload.shipping_address,
        "estimated_delivery_days": 3,
        "tracking_carrier": "Bluedart Express",
    }
