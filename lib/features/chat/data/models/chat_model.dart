import '../../../auth/data/models/user_model.dart';
import '../../domain/entities/chat.dart';

class ChatModel extends Chat {
  const ChatModel({
    required super.id,
    required super.user1,
    required super.user2,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'],
      user1: UserModel.fromJson(json['user1']),
      user2: UserModel.fromJson(json['user2']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user1': UserModel.fromEntity(user1).toJson(),
      'user2': UserModel.fromEntity(user2).toJson(),
    };
  }

  factory ChatModel.fromEntity(Chat chat) {
    return ChatModel(
      id: chat.id,
      user1: UserModel.fromEntity(chat.user1),
      user2: UserModel.fromEntity(chat.user2),
    );
  }
}