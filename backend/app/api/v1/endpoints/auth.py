from fastapi import APIRouter, HTTPException, status
from app.core.security import create_access_token, get_password_hash, verify_password
from app.schemas.auth import OTPRequest, OTPVerify, Token, UserCreate, UserResponse

router = APIRouter()

# In-memory mock store for rapid deployment & testing
MOCK_USERS = {
    "+919876543210": {
        "id": "usr-88192",
        "phone": "+919876543210",
        "full_name": "Rahul Sharma",
        "email": "rahul.sharma@example.com",
        "is_active": True,
        "is_verified": True,
        "is_kyc_approved": True,
        "role": "customer",
    }
}


@router.post("/otp/request")
async def request_otp(payload: OTPRequest):
    return {
        "message": "OTP sent successfully via SMS & WhatsApp",
        "phone": payload.phone,
        "mock_otp_for_dev": "1234",
    }


@router.post("/otp/verify", response_model=Token)
async def verify_otp(payload: OTPVerify):
    if payload.otp not in ["1234", "123456"]:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid OTP entered")

    user_info = MOCK_USERS.get(payload.phone)
    if not user_info:
        user_info = {
            "id": f"usr-{payload.phone[-5:]}",
            "phone": payload.phone,
            "full_name": "Cashify User",
            "email": None,
            "is_active": True,
            "is_verified": True,
            "is_kyc_approved": False,
            "role": "customer",
        }
        MOCK_USERS[payload.phone] = user_info

    access_token = create_access_token(subject=user_info["id"])
    return Token(
        access_token=access_token,
        token_type="bearer",
        user_id=user_info["id"],
        full_name=user_info["full_name"],
        role=user_info["role"],
    )


@router.post("/register", response_model=Token)
async def register(payload: UserCreate):
    user_info = {
        "id": f"usr-{payload.phone[-5:]}",
        "phone": payload.phone,
        "full_name": payload.full_name,
        "email": payload.email,
        "is_active": True,
        "is_verified": True,
        "is_kyc_approved": False,
        "role": "customer",
    }
    MOCK_USERS[payload.phone] = user_info

    access_token = create_access_token(subject=user_info["id"])
    return Token(
        access_token=access_token,
        token_type="bearer",
        user_id=user_info["id"],
        full_name=user_info["full_name"],
        role=user_info["role"],
    )
