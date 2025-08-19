part of 'chat_bloc.dart';

sealed class ChatsState extends Equatable {
  final List<Chat> chats;

  const ChatsState(this.chats);

  @override
  List<Object> get props => [];
}

class ChatsInitial extends ChatsState {
  const ChatsInitial(super.chats);
}

class ChatsLoadSuccess extends ChatsState {
  const ChatsLoadSuccess(super.chats);
}

class ChatsLoadInProgress extends ChatsState {
  const ChatsLoadInProgress(super.chats);
}

class ChatsInitiateInProgress extends ChatsState {
  const ChatsInitiateInProgress(super.chats);
}

class ChatsInitiateSuccess extends ChatsState {
  final Chat addedChat;

  const ChatsInitiateSuccess(this.addedChat, super.chats);
}

class ChatsDeleteInProgress extends ChatsState {
  const ChatsDeleteInProgress(super.chats);
}

class ChatsDeleteSuccess extends ChatsState {
  final String deletedChatName;

  const ChatsDeleteSuccess(this.deletedChatName, super.chats);
}

class ChatsFailure extends ChatsState {
  final String message;

  const ChatsFailure(this.message, super.chats);
}