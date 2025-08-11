import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user.dart';
import 'chat.dart';

class Message extends Equatable {
  final String id;
  final Chat chat;
  final User sender;
  final String type;
  final String content;

  get receiver => chat.user1 == sender ? chat.user2 : chat.user1;

  const Message({
    required this.id,
    required this.chat,
    required this.sender,
    required this.type,
    required this.content,
  });

  @override
  List<Object?> get props => [id, chat, sender, type, content];
}