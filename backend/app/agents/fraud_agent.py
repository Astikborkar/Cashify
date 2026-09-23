from app.schemas.agents import FraudCheckRequest, FraudCheckResponse


class FraudDetectionAgent:
    """Agent 3: Fraud Detection Agent (Risk & Stolen Device Shield).
    Detects IMEI duplication, GSMA stolen phone blacklists,
    GPS mock location spoofing, and excessive listing velocity.
    """

    KNOWN_STOLEN_IMEIS = {
        "358912093819283",
        "990000862471854",
        "867492048192841",
    }

    RECENTLY_LISTED_IMEIS = {
        "354892019482910": 2,
    }

    def inspect_device_risk(self, req: FraudCheckRequest) -> FraudCheckResponse:
        risk_score = 0
        flags = []
        is_blacklisted = False
        is_duplicate = False
        gps_spoofed = False

        # 1. GSMA Blacklist Registry check
        if req.imei in self.KNOWN_STOLEN_IMEIS:
            risk_score += 85
            is_blacklisted = True
            flags.append("GSMA Blacklist match: Reported lost or stolen")

        # 2. IMEI Duplication in past 30 days
        if req.imei in self.RECENTLY_LISTED_IMEIS:
            risk_score += 45
            is_duplicate = True
            flags.append("IMEI submitted across multiple accounts in last 30 days")

        # 3. High Listing Velocity (e.g. > 3 devices in 48 hours)
        if req.listing_velocity_48h > 3:
            risk_score += 30
            flags.append("Sudden high velocity listing: > 3 devices within 48h")

        # 4. GPS Coordinates validation
        if req.gps_lat is not None and req.gps_lng is not None:
            if req.gps_lat == 0.0 and req.gps_lng == 0.0:  # Null Island spoofing
                risk_score += 25
                gps_spoofed = True
                flags.append("GPS mock location detected (0,0)")

        # Decision Matrix from agents.md Section 4.2
        if risk_score <= 25:
            risk_level = "LOW"
            action = "AUTO_APPROVE"
            explanation = "Low Risk. Instant automated pickup approval & instant IMPS payout eligible."
        elif risk_score <= 65:
            risk_level = "MEDIUM"
            action = "MANUAL_INSPECTION"
            explanation = "Medium Risk. Standard pickup with mandatory technician physical serial verification."
        else:
            risk_level = "HIGH"
            action = "FREEZE_AND_BLOCK"
            explanation = "High Risk. Quote frozen. Device flagged for security review."

        return FraudCheckResponse(
            imei=req.imei,
            risk_score=min(100, risk_score),
            risk_level=risk_level,
            is_blacklisted_gsma=is_blacklisted,
            is_imei_duplicate=is_duplicate,
            gps_spoofing_flag=gps_spoofed,
            action_decision=action,
            explanation=explanation if not flags else f"{explanation} Flags: {'; '.join(flags)}",
        )


fraud_agent = FraudDetectionAgent()
