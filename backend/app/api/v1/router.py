from fastapi import APIRouter
from app.api.v1.endpoints import agents, auth, buy, catalog, repair, sell, wallet

api_router = APIRouter()

api_router.include_router(auth.router, prefix="/auth", tags=["Authentication"])
api_router.include_router(catalog.router, prefix="/catalog", tags=["Catalog"])
api_router.include_router(sell.router, prefix="/sell", tags=["Sell Orders"])
api_router.include_router(buy.router, prefix="/buy", tags=["Refurbished Marketplace"])
api_router.include_router(repair.router, prefix="/repair", tags=["Repair Services"])
api_router.include_router(wallet.router, prefix="/wallet", tags=["Wallet & Payouts"])
api_router.include_router(agents.router, prefix="/agents", tags=["AI Multi-Agent Swarm"])
