import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/routes/routes.dart';

import '../../../../core/presentation/widgets/snackbar.dart';
import '../bloc/chat/chat_bloc.dart';
import '../widgets/chat_card.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatsBloc, ChatsState>(
      listener: (context, state) {
        if (state is ChatsFailure) {
          showError(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Chats'),
          actions: [
            IconButton(
              onPressed: () {
                _showStartNewChatDialog(context);
              },
              icon: const Icon(Icons.add_comment),
              tooltip: 'Start New Chat',
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
            child: Column(
              children: [
                // Info Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'How to Chat',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• Tap the + button to start a new chat\n'
                        '• Select a user to chat with\n'
                        '• Your chats will appear here\n'
                        '• Tap on any chat to open the conversation',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Chat List
                Expanded(
                  child: BlocBuilder<ChatsBloc, ChatsState>(
                    builder: (context, state) {
                      if (state.chats.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No chats yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Start a conversation by tapping the + button',
                                style: TextStyle(color: Colors.grey.shade500),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: () {
                                  _showStartNewChatDialog(context);
                                },
                                icon: const Icon(Icons.add_comment),
                                label: const Text('Start New Chat'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).primaryColor,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<ChatsBloc>().add(ChatsLoadRequested());
                        },
                        child: ListView.builder(
                          itemCount: state.chats.length,
                          itemBuilder: (context, index) {
                            final chat = state.chats[index];

                            return ChatCard(
                              chat: chat,
                              onChatSelected: (chat) {
                                context.push(Routes.chatInbox, extra: chat);
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showStartNewChatDialog(BuildContext context) {
    // Navigate directly to the start chat page
    context.push(Routes.startChat);
  }
}
