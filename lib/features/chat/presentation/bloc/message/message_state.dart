part of 'message_bloc.dart';

abstract class MessageState extends Equatable {
  final List<Message> messages;

  const MessageState(this.messages);

  @override
  List<Object> get props => [];
}

class MessageInitial extends MessageState {
  const MessageInitial(super.messages);

  @override
  List<Object> get props => [messages];
}

class MessagesMessageLoadInProgress extends MessageState {
  const MessagesMessageLoadInProgress(super.messages);
}

class MessageLoadSuccess extends MessageState {
  const MessageLoadSuccess(super.messages);

  @override
  List<Object> get props => [messages];
}

class MessageLoadFailure extends MessageState {
  const MessageLoadFailure(super.messages);

  @override
  List<Object> get props => [messages];
}

class MessageSentSuccess extends MessageState {
  const MessageSentSuccess(super.messages);

  @override
  List<Object> get props => [messages];
}

class MessageSentFailure extends MessageState {
  const MessageSentFailure(super.messages);

  @override
  List<Object> get props => [messages];
}