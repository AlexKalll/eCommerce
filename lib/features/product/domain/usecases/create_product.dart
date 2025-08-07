import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class CreateProduct implements UseCase<Product, CreateProductParams> {
  final ProductRepository repository;

  CreateProduct(this.repository);

  @override
  Future<Either<Failure, Product>> call(CreateProductParams params) async {
    return await repository.createProduct(params.product);
  }
}

class CreateProductParams {
  final Product product;

  const CreateProductParams(this.product);
}
