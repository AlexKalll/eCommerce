import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase.dart';
import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

class GetMyChats implements UseCase<List<Chat>, NoParams> {
  final ChatRepository repository;

  const GetMyChats(this.repository);

  @override
  Future<Either<Failure, List<Chat>>> call(NoParams params) async {
    return await repository.getUserChats();
  }
}