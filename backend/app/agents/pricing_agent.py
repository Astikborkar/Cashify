import datetime
from app.schemas.agents import (
    PriceAdjustmentItem,
    PricingQuote,
    PricingRequest,
    PricingResponse,
)


class PricingAIAgent:
    """Agent 1: Dynamic Valuation Engine.
    Implements mathematical depreciation curve and component wear deductions
    as specified in agents.md Section 2.
    """

    def calculate_quote(self, req: PricingRequest, risk_penalty: float = 0.0) -> PricingResponse:
        current_year = datetime.datetime.now().year
        age_years = max(0, current_year - req.device.purchase_year)

        # 1. Base Market Value
        base_market_value = req.market_context.current_refurbished_mkt_avg
        breakdown = []
        breakdown.append(PriceAdjustmentItem(
            item=f"Base {req.device.model} Market Valuation",
            adjustment=round(base_market_value, 2)
        ))

        # 2. Age Depreciation Rate (D_age)
        if age_years <= 1:
            d_age = 0.18
        elif age_years == 2:
            d_age = 0.32
        else:
            d_age = 0.48
        
        age_deduction = -(base_market_value * d_age)
        breakdown.append(PriceAdjustmentItem(
            item=f"Age Depreciation ({age_years} yrs at {int(d_age*100)}%)",
            adjustment=round(age_deduction, 2)
        ))

        current_val = base_market_value * (1 - d_age)

        # 3. Defect Penalties (D_defect)
        # Screen condition
        if req.condition.screen == "cracked":
            screen_penalty = -(current_val * 0.35)
            breakdown.append(PriceAdjustmentItem(item="Cracked Screen Replacement Deduction (-35%)", adjustment=round(screen_penalty, 2)))
            current_val += screen_penalty
        elif req.condition.screen == "minor_scratches":
            screen_penalty = -(current_val * 0.04)
            breakdown.append(PriceAdjustmentItem(item="Screen Micro-scratches Deduction (-4%)", adjustment=round(screen_penalty, 2)))
            current_val += screen_penalty

        # Body condition
        if req.condition.body in ["heavy_dents", "bent"]:
            body_penalty = -(current_val * 0.20)
            breakdown.append(PriceAdjustmentItem(item="Body Severe Dents/Bend Deduction (-20%)", adjustment=round(body_penalty, 2)))
            current_val += body_penalty
        elif req.condition.body == "minor_scratches":
            body_penalty = -(current_val * 0.03)
            breakdown.append(PriceAdjustmentItem(item="Body Wear & Tear Deduction (-3%)", adjustment=round(body_penalty, 2)))
            current_val += body_penalty

        # Battery Health
        bat_health = req.diagnostic_telemetry.battery_health_percentage
        if bat_health < 80:
            bat_penalty = -(current_val * 0.12)
            breakdown.append(PriceAdjustmentItem(item=f"Degraded Battery Health ({bat_health}%) (-12%)", adjustment=round(bat_penalty, 2)))
            current_val += bat_penalty

        # Hardware Functional Issues
        if not req.diagnostic_telemetry.camera_rear_working:
            cam_penalty = -(current_val * 0.20)
            breakdown.append(PriceAdjustmentItem(item="Defective Rear Camera (-20%)", adjustment=round(cam_penalty, 2)))
            current_val += cam_penalty

        if not req.diagnostic_telemetry.biometrics_working:
            bio_penalty = -(current_val * 0.10)
            breakdown.append(PriceAdjustmentItem(item="Biometrics (FaceID/Fingerprint) Inoperable (-10%)", adjustment=round(bio_penalty, 2)))
            current_val += bio_penalty

        # 4. Accessories Bonuses (+5% to +8%)
        if req.device.has_original_box and req.device.has_original_charger:
            acc_bonus = base_market_value * 0.05
            breakdown.append(PriceAdjustmentItem(item="Original Box & OEM Charger Bonus (+5%)", adjustment=round(acc_bonus, 2)))
            current_val += acc_bonus

        if req.device.has_valid_bill:
            bill_bonus = base_market_value * 0.03
            breakdown.append(PriceAdjustmentItem(item="Valid Retail GST Invoice Bonus (+3%)", adjustment=round(bill_bonus, 2)))
            current_val += bill_bonus

        # 5. Risk Penalty from Fraud Detection Shield
        if risk_penalty > 0:
            breakdown.append(PriceAdjustmentItem(item="Risk Assessment Adjustment", adjustment=-round(risk_penalty, 2)))
            current_val -= risk_penalty

        final_price = max(1000.0, round(current_val, 2))

        quote = PricingQuote(
            base_market_value=round(base_market_value, 2),
            final_offer_price=final_price,
            price_breakdown=breakdown,
            confidence_score=0.96,
            price_lock_duration_days=7,
            pickup_priority="EXPRESS_ELIGIBLE" if final_price > 15000 else "STANDARD",
        )
        return PricingResponse(quote=quote)


pricing_agent = PricingAIAgent()
