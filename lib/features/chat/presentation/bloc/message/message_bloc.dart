import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/chat.dart';
import '../../../domain/entities/message.dart';
import '../../../domain/usecases/get_chat_messages.dart';
import '../../../domain/usecases/send_message.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final GetChatMessages getChatMessages;
  final SendMessage sendMessage;

  MessageBloc({
    required this.getChatMessages,
    required this.sendMessage,
  }) : super(const MessageInitial([])) {
    on<MessageSocketConnectionRequested>(_onLoadMessageRequested,
        transformer: restartable());
    on<MessageSent>(_onSendMessageRequested);
  }

  Future<void> _onLoadMessageRequested(MessageSocketConnectionRequested event,
      Emitter<MessageState> emit) async {
    emit(const MessagesMessageLoadInProgress([]));

    final messages =
        await getChatMessages(GetChatMessagesParams(event.chat.id));

    await emit.forEach(messages, onData: (data) {
      final result = data.fold((l) {
        return MessageLoadFailure([...state.messages]);
      }, (r) {
        if (state.messages.isNotEmpty &&
            state.messages[state.messages.length - 1] == r) {
          return MessageLoadSuccess(state.messages);
        }
        return MessageLoadSuccess([...state.messages, r]);
      });

      return result;
    });
  }

  Future<void> _onSendMessageRequested(
      MessageSent event, Emitter<MessageState> emit) async {
    emit(MessagesMessageLoadInProgress(state.messages));

    final result = await sendMessage(
        SendMessageParams(event.chat, event.content, event.type));

    emit(result.fold((l) => MessageSentFailure(state.messages),
        (r) => MessageSentSuccess(state.messages)));
  }
}