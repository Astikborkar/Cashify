from app.schemas.agents import SupportChatRequest, SupportChatResponse


class CustomerSupportAgent:
    """Agent 6: Customer Support Chatbot Agent.
    Handles order status lookups, pickup rescheduling, warranty triage,
    and human agent escalation as defined in agents.md Section 7.
    """

    def process_message(self, req: SupportChatRequest) -> SupportChatResponse:
        text = req.message.lower()
        order_id = req.active_order_id or "REP-84920"

        # 1. Order Status Tracking
        if "track" in text or "status" in text or "order" in text:
            return SupportChatResponse(
                reply=f"🛵 Order #{order_id} is active! Technician Rajesh Kumar is en route with an ETA of ~20 minutes. Verification OTP is 4819.",
                sender_type="ai_bot",
                quick_suggestions=["Call Technician", "Reschedule Slot", "Main Menu"],
                escalate_to_human=False,
                intent_detected="ORDER_STATUS_TRACKING",
            )

        # 2. Rescheduling
        if "reschedule" in text or "change time" in text or "slot" in text:
            return SupportChatResponse(
                reply="📅 You can reschedule free of charge up to 2 hours prior to arrival. Would you like tomorrow morning (10 AM - 12 PM) or afternoon (2 PM - 4 PM)?",
                sender_type="ai_bot",
                quick_suggestions=["Tomorrow 10 AM", "Tomorrow 2 PM", "Keep Current Time"],
                escalate_to_human=False,
                intent_detected="PICKUP_RESCHEDULING",
            )

        # 3. Payout / Refund / Wallet
        if "payout" in text or "refund" in text or "money" in text or "wallet" in text:
            return SupportChatResponse(
                reply="💰 Cashify quotes are paid out immediately via IMPS/UPI upon pickup handover. Your current wallet balance is eligible for 1-click withdrawal.",
                sender_type="ai_bot",
                quick_suggestions=["Go to Wallet", "Check Payout Reference", "Contact Support"],
                escalate_to_human=False,
                intent_detected="REFUND_PAYOUT_INQUIRY",
            )

        # 4. Warranty Claims
        if "warranty" in text or "issue" in text or "broken" in text or "defect" in text:
            return SupportChatResponse(
                reply="🛡️ Doorstep repairs include a 6-month genuine parts warranty. Please specify if you are experiencing touch lag, battery drain, or physical damage to create a priority claim.",
                sender_type="ai_bot",
                quick_suggestions=["Screen Touch Issue", "Battery Drain", "Talk to Specialist"],
                escalate_to_human=False,
                intent_detected="WARRANTY_CLAIM",
            )

        # 5. Human Escalation Trigger
        if "human" in text or "agent" in text or "complaint" in text or "fraud" in text or "angry" in text:
            return SupportChatResponse(
                reply="👨‍💼 Connecting you to Senior Support Specialist Sarah... Chat history and active order context have been transferred.",
                sender_type="human_agent",
                quick_suggestions=["Wait for Specialist", "Cancel Request"],
                escalate_to_human=True,
                intent_detected="HUMAN_ESCALATION",
            )

        # Fallback
        return SupportChatResponse(
            reply=f"I'm here to help with your Cashify experience! You can track order #{order_id}, request pickup rescheduling, or check warranty coverage.",
            sender_type="ai_bot",
            quick_suggestions=["Track My Order", "Wallet Payout", "Talk to Human Agent"],
            escalate_to_human=False,
            intent_detected="GENERAL_HELP",
        )


support_agent = CustomerSupportAgent()
