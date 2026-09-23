from typing import List
from app.schemas.agents import (
    RecommendationRequest,
    RecommendationResponse,
    RecommendedProduct,
)


class RecommendationAgent:
    """Agent 5: Recommendation Agent (Personalized Phone Matchmaker).
    Understands user intent, budget limits, preferred brands, and
    calculates trade-in effective pricing.
    """

    CATALOG_SAMPLE = [
        {"id": "prod-1", "title": "Apple iPhone 13 (128GB)", "brand": "Apple", "grade": "Superb", "price": 38999.0, "reason": "Best overall camera, 5G, and 85%+ battery health guaranteed."},
        {"id": "prod-2", "title": "Apple iPhone 12 (128GB)", "brand": "Apple", "grade": "Superb", "price": 28499.0, "reason": "Top pick under ₹30,000 with OLED Ceramic Shield."},
        {"id": "prod-3", "title": "Samsung Galaxy S22 5G (128GB)", "brand": "Samsung", "grade": "Superb", "price": 29999.0, "reason": "Snapdragon 8 Gen 1 dynamic AMOLED flagship under ₹30k."},
        {"id": "prod-4", "title": "OnePlus 11R 5G (128GB)", "brand": "OnePlus", "grade": "Good", "price": 24999.0, "reason": "100W SuperVOOC ultra-fast charging and 120Hz Fluid AMOLED."},
        {"id": "prod-5", "title": "Google Pixel 7 (128GB)", "brand": "Google", "grade": "Superb", "price": 27999.0, "reason": "Class-leading AI computational photography and clean Android."},
    ]

    def recommend(self, req: RecommendationRequest) -> RecommendationResponse:
        trade_in_credit = req.trade_in_estimated_value or 0.0
        results: List[RecommendedProduct] = []

        for p in self.CATALOG_SAMPLE:
            # Filter by budget if provided
            if req.max_budget and p["price"] > req.max_budget:
                continue

            # Filter by brand if specified
            if req.preferred_brands and p["brand"] not in req.preferred_brands:
                continue

            effective_price = max(0.0, p["price"] - trade_in_credit) if trade_in_credit > 0 else None

            results.append(RecommendedProduct(
                product_id=p["id"],
                title=p["title"],
                grade=p["grade"],
                price=p["price"],
                effective_trade_in_price=effective_price,
                highlight_reason=p["reason"],
            ))

        if not results:
            # Fallback to top items
            for p in self.CATALOG_SAMPLE[:2]:
                results.append(RecommendedProduct(
                    product_id=p["id"],
                    title=p["title"],
                    grade=p["grade"],
                    price=p["price"],
                    effective_trade_in_price=max(0.0, p["price"] - trade_in_credit) if trade_in_credit > 0 else None,
                    highlight_reason=p["reason"],
                ))

        return RecommendationResponse(
            user_intent=req.query,
            recommendations=results,
        )


recommendation_agent = RecommendationAgent()
