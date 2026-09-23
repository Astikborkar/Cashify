import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../domain/models/support_chat_message.dart';
import '../providers/support_chat_provider.dart';

class SupportChatScreen extends ConsumerStatefulWidget {
  const SupportChatScreen({super.key});

  @override
  ConsumerState<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends ConsumerState<SupportChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend([String? presetText]) {
    final text = presetText ?? _textController.text.trim();
    if (text.isEmpty) return;
    if (presetText == null) _textController.clear();

    ref.read(supportChatNotifierProvider.notifier).sendMessage(text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(supportChatNotifierProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: chatState.isHumanEscalated ? 'Human Support Specialist' : 'Cashify AI Assistant',
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: chatState.isHumanEscalated
                  ? AppColors.secondary.withAlpha(50)
                  : AppColors.success.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: chatState.isHumanEscalated ? AppColors.secondaryDark : AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  chatState.isHumanEscalated ? 'Live Agent' : 'Agent 6 Active',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: chatState.isHumanEscalated ? AppColors.secondaryDark : AppColors.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (chatState.isHumanEscalated)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: AppColors.secondaryLight.withAlpha(76),
              child: const Row(
                children: [
                  Icon(Icons.shield_outlined, size: 16, color: AppColors.neutral800),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Escalated to human support team. Verified order context passed.',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.neutral800),
                    ),
                  ),
                ],
              ),
            ),

          // Messages View
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: AppSpacing.screenPadding,
              itemCount: chatState.messages.length,
              itemBuilder: (context, index) {
                final msg = chatState.messages[index];
                final isUser = msg.sender == MessageSender.user;

                return Column(
                  crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (!isUser) ...[
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: msg.sender == MessageSender.humanAgent
                                ? AppColors.secondary
                                : AppColors.primary,
                            child: Icon(
                              msg.sender == MessageSender.humanAgent
                                  ? Icons.person_rounded
                                  : Icons.smart_toy_rounded,
                              size: 14,
                              color: msg.sender == MessageSender.humanAgent
                                  ? AppColors.neutral900
                                  : Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? AppColors.primary
                                  : (msg.sender == MessageSender.humanAgent
                                      ? AppColors.secondaryLight
                                      : Colors.white),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                                bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
                              ),
                              border: isUser ? null : Border.all(color: AppColors.neutral200),
                              boxShadow: isUser
                                  ? null
                                  : [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(10),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                            ),
                            child: Text(
                              msg.text,
                              style: TextStyle(
                                fontSize: 14,
                                color: isUser ? Colors.white : AppColors.neutral900,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Quick suggestion chips
                    if (msg.quickReplies.isNotEmpty && index == chatState.messages.length - 1) ...[
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: msg.quickReplies.map((reply) {
                          return ActionChip(
                            label: Text(reply),
                            backgroundColor: AppColors.primaryLight,
                            labelStyle: const TextStyle(
                              color: AppColors.primaryDark,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                            onPressed: () => _handleSend(reply),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ],
                );
              },
            ),
          ),

          // Typing Indicator
          if (chatState.isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: [
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    chatState.isHumanEscalated ? 'Agent Sarah is typing...' : 'AI Assistant is thinking...',
                    style: const TextStyle(fontSize: 12, color: AppColors.neutral500, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),

          // Message Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.neutral200)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Type your message or query...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(fontSize: 14, color: AppColors.neutral400),
                      ),
                      onSubmitted: (_) => _handleSend(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send_rounded, color: AppColors.primary),
                    onPressed: () => _handleSend(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
