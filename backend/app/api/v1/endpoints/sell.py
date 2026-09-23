import uuid
from typing import Any, Dict
from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter()


class SchedulePickupRequest(BaseModel):
    variant_id: str
    quote_price: float
    pickup_address: str
    pickup_date: str
    pickup_slot: str
    payment_method: str = "WALLET"  # WALLET, UPI, BANK


@router.post("/orders/schedule")
async def schedule_sell_pickup(payload: SchedulePickupRequest):
    order_code = f"SO-{str(uuid.uuid4().int)[:5]}"
    otp = "4819"
    return {
        "status": "SUCCESS",
        "order_code": order_code,
        "pickup_date": payload.pickup_date,
        "pickup_slot": payload.pickup_slot,
        "pickup_address": payload.pickup_address,
        "quote_price": payload.quote_price,
        "handover_otp": otp,
        "message": f"Pickup scheduled! Technician will ask for verification OTP {otp} upon arrival.",
    }
