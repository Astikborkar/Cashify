import uuid
from typing import List
from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter()

MOCK_REPAIR_ISSUES = [
    {
        "id": "iss-screen",
        "title": "Screen Glass Replacement",
        "description": "Original high-grade glass replacement with 6 months warranty",
        "price": 1999.0,
        "original_price": 2899.0,
        "turnaround_minutes": 30,
        "warranty_months": 6,
    },
    {
        "id": "iss-battery",
        "title": "Battery Replacement",
        "description": "OEM certified battery with 100% capacity",
        "price": 1499.0,
        "original_price": 2199.0,
        "turnaround_minutes": 25,
        "warranty_months": 6,
    },
    {
        "id": "iss-charging",
        "title": "Charging Port Repair",
        "description": "Fix loose connector, slow charging or headphone jack issue",
        "price": 899.0,
        "original_price": 1299.0,
        "turnaround_minutes": 20,
        "warranty_months": 6,
    },
    {
        "id": "iss-camera",
        "title": "Rear Camera Glass",
        "description": "Sapphire crystal lens replacement for blurry / cracked camera",
        "price": 699.0,
        "original_price": 999.0,
        "turnaround_minutes": 20,
        "warranty_months": 6,
    },
]


class BookRepairRequest(BaseModel):
    device_model: str
    issue_ids: List[str]
    total_amount: float
    address: str
    date: str
    slot: str


@router.get("/issues")
async def list_repair_issues():
    return MOCK_REPAIR_ISSUES


@router.post("/book")
async def book_doorstep_repair(payload: BookRepairRequest):
    order_code = f"REP-{str(uuid.uuid4().int)[:5]}"
    return {
        "status": "TECHNICIAN_ASSIGNED",
        "order_code": order_code,
        "device_model": payload.device_model,
        "total_amount": payload.total_amount,
        "technician": {
            "name": "Rajesh Kumar",
            "phone": "+91 98112 00491",
            "rating": 4.9,
            "repairs_completed": 1420,
            "eta_minutes": 25,
            "service_otp": "4819",
        },
        "service_address": payload.address,
        "scheduled_date": payload.date,
        "scheduled_slot": payload.slot,
    }
