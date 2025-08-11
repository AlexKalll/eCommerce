part of 'chat_bloc.dart';

sealed class ChatsEvent extends Equatable {
  const ChatsEvent();

  @override
  List<Object> get props => [];
}

class ChatsLoadRequested extends ChatsEvent {}

class ChatsChatInitiated extends ChatsEvent {
  final User receiver;

  const ChatsChatInitiated(this.receiver);

  @override
  List<Object> get props => [receiver];
}