import '../../../auth/data/models/user_model.dart';
import '../../domain/entities/message.dart';
import 'chat_model.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.chat,
    required super.sender,
    required super.type,
    required super.content,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'],
      chat: ChatModel.fromJson(json['chat']),
      sender: UserModel.fromJson(json['sender']),
      type: json['type'] ?? 'text',
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat': ChatModel.fromEntity(chat).toJson(),
      'sender': UserModel.fromEntity(sender).toJson(),
    };
  }
}