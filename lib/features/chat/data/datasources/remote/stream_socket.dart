import 'dart:async';

import '../../models/message_model.dart';

class StreamSocket {
  final _socketResponse = StreamController<MessageModel>();

  void Function(MessageModel) get addResponse => _socketResponse.sink.add;

  Stream<MessageModel> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}