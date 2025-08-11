part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class MessageSocketConnectionRequested extends MessageEvent {
  final Chat chat;

  const MessageSocketConnectionRequested(this.chat);
}

class MessageSent extends MessageEvent {
  final Chat chat;
  final String content;
  final String type;

  const MessageSent(
    this.chat,
    this.content,
    this.type,
  );
}