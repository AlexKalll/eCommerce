import 'package:shared_preferences/shared_preferences.dart';

import '../../models/chat_model.dart';
import 'chat_local_data_source.dart';

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final SharedPreferences sharedPreferences;

  ChatLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheChat(ChatModel chat) async {
    // TODO: implement proper caching
    // For now, just return without error
  }

  @override
  Future<void> cacheChats(List<ChatModel> chats) async {
    // TODO: implement proper caching
    // For now, just return without error
  }

  @override
  Future<ChatModel> getChat(String id) async {
    // TODO: implement proper retrieval
    // For now, throw an error to indicate not implemented
    throw UnimplementedError('Chat local storage not implemented yet');
  }

  @override
  Future<List<ChatModel>> getChats() async {
    // TODO: implement proper retrieval
    // For now, return empty list to prevent crashes
    return [];
  }
}
