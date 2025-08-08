import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/product.dart';

// Define the ProductRepository repository interface, which may include methods for fetching, creating, updating, and deleting products from the data source through API calls, database queries, or other means.

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, Product>> getProduct(String id);
  Future<Either<Failure, Product>> createProduct(Product product);
  Future<Either<Failure, Product>> updateProduct(Product product);
  Future<Either<Failure, Unit>> deleteProduct(String id);
}
