import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProduct implements UseCase<Product, GetProductParams> {
  final ProductRepository repository;

  GetProduct(this.repository);

  @override
  Future<Either<Failure, Product>> call(GetProductParams params) async {
    return await repository.getProduct(params.id);
  }
}

class GetProductParams {
  final String id;

  const GetProductParams(this.id);
}
