import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/support_chat_message.dart';

class SupportChatState {
  final List<SupportChatMessage> messages;
  final bool isTyping;
  final bool isHumanEscalated;

  const SupportChatState({
    required this.messages,
    this.isTyping = false,
    this.isHumanEscalated = false,
  });

  SupportChatState copyWith({
    List<SupportChatMessage>? messages,
    bool? isTyping,
    bool? isHumanEscalated,
  }) {
    return SupportChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      isHumanEscalated: isHumanEscalated ?? this.isHumanEscalated,
    );
  }
}

class SupportChatNotifier extends StateNotifier<SupportChatState> {
  SupportChatNotifier()
      : super(
          SupportChatState(
            messages: [
              SupportChatMessage(
                id: 'MSG-INIT',
                sender: MessageSender.aiBot,
                text: 'Hello Rahul! 👋 I am your Cashify AI Assistant.\nHow can I help you today?',
                timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
                quickReplies: [
                  'Track Repair #REP-84920',
                  'Wallet Payout Status',
                  'Reschedule Pickup',
                  'File Warranty Claim',
                  'Talk to Human Agent',
                ],
              ),
            ],
          ),
        );

  Future<void> sendMessage(String text) async {
    final userMsg = SupportChatMessage(
      id: 'MSG-${DateTime.now().millisecondsSinceEpoch}',
      sender: MessageSender.user,
      text: text,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isTyping: true,
    );

    await Future.delayed(const Duration(milliseconds: 900));

    // Agent 6 Decision Engine
    SupportChatMessage botReply;
    final lower = text.toLowerCase();

    if (lower.contains('track') || lower.contains('rep-84920')) {
      botReply = SupportChatMessage(
        id: 'MSG-REPLY-${DateTime.now().millisecondsSinceEpoch}',
        sender: MessageSender.aiBot,
        text: '🛵 Your doorstep repair order #REP-84920 is active!\n\nTechnician: Rajesh Kumar\nContact: +91 98112 00491\nETA: ~25 minutes\nSecurity OTP for service handover: 4819',
        timestamp: DateTime.now(),
        quickReplies: ['Call Technician', 'Reschedule Slot', 'Main Menu'],
      );
    } else if (lower.contains('payout') || lower.contains('wallet') || lower.contains('refund')) {
      botReply = SupportChatMessage(
        id: 'MSG-REPLY-${DateTime.now().millisecondsSinceEpoch}',
        sender: MessageSender.aiBot,
        text: '💰 Your wallet balance is ₹3,250.\nYour last sell order #SO-77491 payout of ₹27,400 was successfully processed via instant IMPS.\n\nWould you like to initiate a bank or UPI withdrawal?',
        timestamp: DateTime.now(),
        quickReplies: ['Go to Wallet', 'Download Invoice', 'Main Menu'],
      );
    } else if (lower.contains('reschedule')) {
      botReply = SupportChatMessage(
        id: 'MSG-REPLY-${DateTime.now().millisecondsSinceEpoch}',
        sender: MessageSender.aiBot,
        text: '📅 No problem! You can reschedule your pickup or repair anytime 2 hours before the technician arrives. Would you like tomorrow morning (10 AM - 12 PM) or afternoon (2 PM - 4 PM)?',
        timestamp: DateTime.now(),
        quickReplies: ['Tomorrow 10 AM', 'Tomorrow 2 PM', 'Keep Current Slot'],
      );
    } else if (lower.contains('human') || lower.contains('agent') || lower.contains('talk')) {
      state = state.copyWith(isHumanEscalated: true);
      botReply = SupportChatMessage(
        id: 'MSG-REPLY-${DateTime.now().millisecondsSinceEpoch}',
        sender: MessageSender.humanAgent,
        text: '👨‍💼 Connecting you to Senior Support Specialist Sarah...\n\nHello Rahul, I have received the chat transcript and order context. How can I assist you with your Cashify experience today?',
        timestamp: DateTime.now(),
        isEscalated: true,
        quickReplies: ['Complaint regarding payout', 'Device condition query'],
      );
    } else if (lower.contains('warranty') || lower.contains('claim')) {
      botReply = SupportChatMessage(
        id: 'MSG-REPLY-${DateTime.now().millisecondsSinceEpoch}',
        sender: MessageSender.aiBot,
        text: '🛡️ Cashify Doorstep Repair comes with a 6-month genuine parts warranty, and Refurbished Phones include a 12-month replacement warranty.\n\nPlease describe the issue (e.g., touch unresponsive, battery drain) so I can generate a pre-approved warranty claim ticket.',
        timestamp: DateTime.now(),
        quickReplies: ['Touch Screen Issue', 'Battery Problem', 'Talk to Human Agent'],
      );
    } else {
      botReply = SupportChatMessage(
        id: 'MSG-REPLY-${DateTime.now().millisecondsSinceEpoch}',
        sender: MessageSender.aiBot,
        text: 'I understand you are asking about "$text". Let me look into our knowledge base for you. You can also pick from common topics below:',
        timestamp: DateTime.now(),
        quickReplies: [
          'Track Repair #REP-84920',
          'Wallet Payout Status',
          'Talk to Human Agent',
        ],
      );
    }

    state = state.copyWith(
      messages: [...state.messages, botReply],
      isTyping: false,
    );
  }
}

final supportChatNotifierProvider =
    StateNotifierProvider<SupportChatNotifier, SupportChatState>((ref) {
  return SupportChatNotifier();
});
