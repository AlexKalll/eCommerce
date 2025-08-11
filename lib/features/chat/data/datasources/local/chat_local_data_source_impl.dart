import 'package:shared_preferences/shared_preferences.dart';

import '../../models/chat_model.dart';
import 'chat_local_data_source.dart';

class ChatLocalDataSourceImpl extends ChatLocalDataSource {
  final SharedPreferences sharedPreferences;

  ChatLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheChat(ChatModel chat) {
    throw UnimplementedError();
  }

  @override
  Future<void> cacheChats(List<ChatModel> products) {
    // TODO: implement cacheChats
    throw UnimplementedError();
  }

  @override
  Future<ChatModel> getChat(String id) {
    // TODO: implement getChat
    throw UnimplementedError();
  }

  @override
  Future<List<ChatModel>> getChats() {
    // TODO: implement getChats
    throw UnimplementedError();
  }
}