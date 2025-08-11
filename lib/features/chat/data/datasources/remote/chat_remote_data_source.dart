import '../../../../auth/data/models/user_model.dart';
import '../../models/chat_model.dart';
import '../../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<void> deleteChat(String id);
  Future<ChatModel> getOrCreateChat(UserModel receiver);
  Future<List<ChatModel>> getUserChats();
  void sendMessage(String chat, String message, String type);
  Stream<MessageModel> getChatMessages(String id);
}