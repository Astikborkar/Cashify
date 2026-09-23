import uuid
from typing import Optional
from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter()


class WithdrawalRequest(BaseModel):
    amount: float
    method: str  # UPI, BANK
    upi_id: Optional[str] = None
    account_number: Optional[str] = None
    ifsc_code: Optional[str] = None


@router.get("/balance")
async def get_wallet_balance(user_id: str = "usr-88192"):
    return {
        "total_balance": 3250.0,
        "cashback_balance": 1250.0,
        "referral_balance": 2000.0,
        "pending_payout": 0.0,
        "currency": "INR",
    }


@router.post("/withdraw")
async def request_withdrawal(payload: WithdrawalRequest):
    ref_id = f"IMPS-{str(uuid.uuid4().int)[:8]}"
    return {
        "status": "PROCESSED",
        "reference_id": ref_id,
        "amount": payload.amount,
        "method": payload.method,
        "message": f"Instant IMPS transfer of ₹{payload.amount:.0f} credited to {payload.upi_id or payload.account_number}.",
    }
