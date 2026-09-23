from typing import Optional
from pydantic import BaseModel, EmailStr, Field


class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user_id: str
    full_name: str
    role: str


class OTPRequest(BaseModel):
    phone: str = Field(..., description="10-digit mobile number with or without +91")


class OTPVerify(BaseModel):
    phone: str
    otp: str = Field(..., min_length=4, max_length=6)


class UserCreate(BaseModel):
    phone: str
    full_name: str
    email: Optional[EmailStr] = None
    password: Optional[str] = None


class UserResponse(BaseModel):
    id: str
    phone: str
    full_name: str
    email: Optional[str] = None
    is_active: bool
    is_verified: bool
    is_kyc_approved: bool
    role: str

    class Config:
        from_attributes = True
