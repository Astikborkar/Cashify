enum MessageSender {
  user,
  aiBot,
  humanAgent,
}

class SupportChatMessage {
  final String id;
  final MessageSender sender;
  final String text;
  final DateTime timestamp;
  final List<String> quickReplies;
  final bool isEscalated;

  const SupportChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    this.quickReplies = const [],
    this.isEscalated = false,
  });
}
