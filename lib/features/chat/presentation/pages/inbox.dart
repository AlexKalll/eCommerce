import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/widgets/snackbar.dart';
import '../../domain/entities/chat.dart';
import '../bloc/message/message_bloc.dart';

import '../widgets/message_card.dart';

class ChatInboxPage extends StatefulWidget {
  final Chat chat;
  const ChatInboxPage({super.key, required this.chat});

  @override
  State<ChatInboxPage> createState() => _ChatInboxPageState();
}

class _ChatInboxPageState extends State<ChatInboxPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MessageBloc>().add(
      MessageSocketConnectionRequested(widget.chat),
    );
    _messageController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MessageBloc, MessageState>(
      listener: (context, state) {
        if (state is MessageLoadFailure) {
          showError(context, 'Loading failed');
        } else if (state is MessageSentSuccess) {
          _messageController.clear();
        } else if (state is MessageSentFailure) {
          showError(context, 'Sending failed');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Chat with ${_getOtherUserName()}'),
              Text(
                'Tap to send messages',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
            child: Column(
              children: [
                // Chat Info Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.green.shade700,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'You are chatting with ${_getOtherUserName()}. Type your message below and tap send.',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Message List
                Expanded(
                  child: BlocBuilder<MessageBloc, MessageState>(
                    builder: (context, state) {
                      if (state.messages.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.message_outlined,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No messages yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Start the conversation by sending a message',
                                style: TextStyle(color: Colors.grey.shade500),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<MessageBloc>().add(
                            MessageSocketConnectionRequested(widget.chat),
                          );
                        },
                        child: ListView.builder(
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            final message = state.messages[index];

                            return MessageCard(message: message);
                          },
                        ),
                      );
                    },
                  ),
                ),

                // Message Input
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          maxLines: null,
                        ),
                      ),
                      IconButton(
                        onPressed: _messageController.text.trim().isEmpty
                            ? null
                            : () {
                                context.read<MessageBloc>().add(
                                  MessageSent(
                                    widget.chat,
                                    _messageController.text.trim(),
                                    'text',
                                  ),
                                );
                              },
                        icon: Icon(
                          Icons.send,
                          color: _messageController.text.trim().isEmpty
                              ? Colors.grey.shade400
                              : Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getOtherUserName() {
    return '${widget.chat.user1.name} & ${widget.chat.user2.name}';
  }
}
