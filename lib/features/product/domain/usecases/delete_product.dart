import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase.dart';
import '../repositories/product_repository.dart';

class DeleteProduct implements UseCase<Unit, DeleteProductParams> {
  final ProductRepository repository;

  DeleteProduct(this.repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteProductParams params) async {
    return await repository.deleteProduct(params.id);
  }
}

class DeleteProductParams {
  final String id;

  const DeleteProductParams(this.id);
}
