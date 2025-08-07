import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class UpdateProduct implements UseCase<Product, UpdateProductParams> {
  final ProductRepository repository;

  UpdateProduct(this.repository);

  @override
  Future<Either<Failure, Product>> call(UpdateProductParams params) async {
    return await repository.updateProduct(params.product);
  }
}

class UpdateProductParams {
  final Product product;

  const UpdateProductParams(this.product);
}
