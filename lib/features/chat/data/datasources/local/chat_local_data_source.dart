import '../../models/chat_model.dart';

abstract class ChatLocalDataSource {
  Future<void> cacheChats(List<ChatModel> products);
  Future<void> cacheChat(ChatModel product);
  Future<List<ChatModel>> getChats();
  Future<ChatModel> getChat(String id);
}