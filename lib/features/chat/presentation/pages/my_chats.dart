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
          title: const Text('Chats'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
            child: Column(
              children: [
                // Chat List
                Expanded(
                  child: BlocBuilder<ChatsBloc, ChatsState>(
                    builder: (context, state) {
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
                                });
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
}