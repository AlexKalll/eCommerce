import 'package:dartz/dartz.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/product.dart';

import '../../domain/repositories/product_repository.dart';
import '../data_sources/local/local_data_source.dart';
import '../data_sources/remote/remote_data_source.dart';
import '../models/product_mapper.dart';

class ProductRepositoryImpl extends ProductRepository {
  final ProductRemoteDataSource _productRemoteDataSource;
  final ProductLocalDataSource _productLocalDataSource;
  final NetworkInfo _networkInfo;

  ProductRepositoryImpl({
    required NetworkInfo networkInfo,
    required ProductRemoteDataSource remoteDataSource,
    required ProductLocalDataSource localDataSource,
  })  : _networkInfo = networkInfo,
        _productRemoteDataSource = remoteDataSource,
        _productLocalDataSource = localDataSource;

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    if (await _networkInfo.isConnected) {
      try {
        final products = await _productRemoteDataSource.getProducts();
        _productLocalDataSource.cacheProducts(products);
        return Right(products);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final products = await _productLocalDataSource.getProducts();
        return Right(products);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, Product>> getProduct(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final product = await _productRemoteDataSource.getProduct(id);
        _productLocalDataSource.cacheProduct(product);
        return Right(product);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final product = await _productLocalDataSource.getProduct(id);
        return Right(product);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, Product>> createProduct(Product product) async {
    final productModel = product.toModel();

    if (await _networkInfo.isConnected) {
      try {
        await _productRemoteDataSource.createProduct(productModel);
        _productLocalDataSource.cacheProduct(productModel);
        return Right(product);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteProduct(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        await _productRemoteDataSource.deleteProduct(id);
        _productLocalDataSource.deleteProduct(id);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Product>> updateProduct(Product product) async {
    final productModel = product.toModel();

    if (await _networkInfo.isConnected) {
      try {
        await _productRemoteDataSource.updateProduct(productModel);
        _productLocalDataSource.cacheProduct(productModel);
        return Right(product);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }
}