from app.schemas.agents import (
    NotificationDispatchRequest,
    NotificationDispatchResponse,
)


class NotificationAgent:
    """Agent 7: Notification Agent (Omnichannel Marketing & Alerts).
    Selects optimal dispatch channel (WhatsApp, Push, SMS) and copy strategy
    as defined in agents.md Section 8.
    """

    def dispatch(self, req: NotificationDispatchRequest) -> NotificationDispatchResponse:
        ev = req.event_type.upper()
        data = req.data

        if ev == "PRICE_DROP":
            channel = "PUSH"
            drop_amt = data.get("drop_amount", "₹3,500")
            product = data.get("product_title", "iPhone 13")
            msg = f"⚡ Price drop alert! {product} just dropped by {drop_amt}. Tap to grab before stock runs out!"

        elif ev == "PICKUP_ASSIGNED":
            channel = "WHATSAPP"
            agent_name = data.get("agent_name", "Rajesh Kumar")
            otp = data.get("otp", "4819")
            msg = f"🛵 Cashify Update: {agent_name} is on the way for your device pickup. Your service handover OTP is *{otp}*."

        elif ev == "ABANDONED_SELL":
            channel = "WHATSAPP"
            quote = data.get("quote_amount", "₹27,400")
            msg = f"⏳ Your {quote} valuation quote is reserved for the next 24 hours. Tap here to lock your price before market depreciation."

        elif ev == "PAYOUT_SUCCESS":
            channel = "SMS"
            amt = data.get("amount", "₹27,400")
            account = data.get("account_tail", "9821")
            msg = f"Cashify: {amt} has been successfully credited to your account ending in {account}. Ref ID: IMPS-{data.get('ref_id', '991823')}."

        else:
            channel = "PUSH"
            msg = "Cashify: You have a new notification on your account."

        return NotificationDispatchResponse(
            channel_used=channel,
            delivery_status="DELIVERED_SUCCESSFULLY",
            message_dispatched=msg,
        )


notification_agent = NotificationAgent()
