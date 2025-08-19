import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class GetChatMessages {
  final ChatRepository repository;

  const GetChatMessages(this.repository);

  Future<Stream<Either<Failure, Message>>> call(
      GetChatMessagesParams params) async {
    return await repository.getChatMessages(params.id);
  }
}

class GetChatMessagesParams extends Equatable {
  final String id;

  const GetChatMessagesParams(this.id);

  @override
  List<Object?> get props => [id];
}