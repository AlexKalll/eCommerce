import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/exception.dart';
import 'package:ecommerce/core/error/failure.dart';
import 'package:ecommerce/core/network/network_info.dart';
import 'package:ecommerce/features/product/data/data_sources/local/local_data_source.dart';
import 'package:ecommerce/features/product/data/data_sources/remote/remote_data_source.dart';
import 'package:ecommerce/features/product/data/models/product_model.dart';
import 'package:ecommerce/features/product/data/repositories/product_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ProductRemoteDataSource>(as: #MockProductRemoteDataSource),
  MockSpec<ProductLocalDataSource>(as: #MockProductLocalDataSource),
  MockSpec<NetworkInfo>(as: #MockNetworkInfo),
])
void main() {
  late MockProductRemoteDataSource mockProductRemoteDataSource;
  late MockProductLocalDataSource mockProductLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late ProductRepositoryImpl productRepository;

  setUp(() {
    mockProductRemoteDataSource = MockProductRemoteDataSource();
    mockProductLocalDataSource = MockProductLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    productRepository = ProductRepositoryImpl(
        networkInfo: mockNetworkInfo,
        remoteDataSource: mockProductRemoteDataSource,
        localDataSource: mockProductLocalDataSource);
  });

  const tProductId = 'id';
  const tProduct = ProductModel(
      id: tProductId,
      name: 'name',
      description: 'description',
      price: 123.45,
      imageUrl: 'https://product.image.com/id');
  const tProducts = [tProduct];

  group('when network is available', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    group('getProducts', () {
      test('should get products from remote data source', () async {
        when(mockProductRemoteDataSource.getProducts())
            .thenAnswer((_) async => tProducts);

        final result = await productRepository.getProducts();

        expect(result, const Right(tProducts));
        verify(mockProductRemoteDataSource.getProducts());
      });

      test('should cache products from remote data source', () async {
        when(mockProductRemoteDataSource.getProducts())
            .thenAnswer((_) async => tProducts);

        await productRepository.getProducts();

        verify(mockProductRemoteDataSource.getProducts());
        verify(mockProductLocalDataSource.cacheProducts(tProducts));
      });

      test(
          'should return server failure when remote data source throws server exception',
          () async {
        when(mockProductRemoteDataSource.getProducts())
            .thenThrow(const ServerException(message: 'Server Exception'));

        final result = await productRepository.getProducts();

        expect(result, const Left(ServerFailure('Server Exception')));
      });
    });

    group('getProduct', () {
      test('should get product from remote data source', () async {
        when(mockProductRemoteDataSource.getProduct(tProductId))
            .thenAnswer((_) async => tProduct);

        final result = await productRepository.getProduct(tProductId);

        expect(result, const Right(tProduct));
        verify(mockProductRemoteDataSource.getProduct(tProductId));
      });

      test('should cache product from remote data source', () async {
        when(mockProductRemoteDataSource.getProduct(tProductId))
            .thenAnswer((_) async => tProduct);

        await productRepository.getProduct(tProductId);

        verify(mockProductRemoteDataSource.getProduct(tProductId));
        verify(mockProductLocalDataSource.cacheProduct(tProduct));
      });

      test(
          'should return server failure when remote data source throws server exception',
          () async {
        when(mockProductRemoteDataSource.getProduct(tProductId))
            .thenThrow(const ServerException(message: 'Server Exception'));

        final result = await productRepository.getProduct(tProductId);

        expect(result, const Left(ServerFailure('Server Exception')));
      });
    });

    group('createProduct', () {
      test('should create product from remote data source', () async {
        when(mockProductRemoteDataSource.createProduct(tProduct))
            .thenAnswer((_) async => tProduct);

        final result = await productRepository.createProduct(tProduct);

        expect(result, const Right(tProduct));
        verify(mockProductRemoteDataSource.createProduct(tProduct));
      });

      test(
          'should return server failure when remote data source throws server exception',
          () async {
        when(mockProductRemoteDataSource.createProduct(tProduct))
            .thenThrow(const ServerException(message: 'Server Exception'));

        final result = await productRepository.createProduct(tProduct);

        expect(result, const Left(ServerFailure('Server Exception')));
      });
    });

    group('deleteProduct', () {
      test('should delete product from remote data source', () async {
        await productRepository.deleteProduct(tProductId);

        verify(mockProductRemoteDataSource.deleteProduct(tProductId));
      });

      test(
          'should return server failure when remote data source throws server exception',
          () async {
        when(mockProductRemoteDataSource.deleteProduct(tProductId))
            .thenThrow(const ServerException(message: 'Server Exception'));

        final result = await productRepository.deleteProduct(tProductId);

        expect(result, const Left(ServerFailure('Server Exception')));
      });
    });

    group('updateProduct', () {
      test('should update product from remote data source', () async {
        when(mockProductRemoteDataSource.updateProduct(tProduct))
            .thenAnswer((_) async => tProduct);

        final result = await productRepository.updateProduct(tProduct);

        expect(result, const Right(tProduct));

        verify(mockProductRemoteDataSource.updateProduct(tProduct));
      });

      test('should update cache product from remote data source', () async {
        when(mockProductRemoteDataSource.updateProduct(tProduct))
            .thenAnswer((_) async => tProduct);

        await productRepository.updateProduct(tProduct);

        verify(mockProductRemoteDataSource.updateProduct(tProduct));
        verify(mockProductLocalDataSource.cacheProduct(tProduct));
      });

      test(
          'should return server failure when remote data source throws server exception',
          () async {
        when(mockProductRemoteDataSource.updateProduct(tProduct))
            .thenThrow(const ServerException(message: 'Server Exception'));

        final result = await productRepository.updateProduct(tProduct);

        expect(result, const Left(ServerFailure('Server Exception')));
      });
    });
  });

  group('when network is not available', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });

    group('getProducts', () {
      test('should get products from local data source', () async {
        when(mockProductLocalDataSource.getProducts())
            .thenAnswer((_) async => tProducts);

        final result = await productRepository.getProducts();

        expect(result, const Right(tProducts));
        verify(mockProductLocalDataSource.getProducts());
      });

      test('should not call remote data source', () async {
        await productRepository.getProducts();

        verifyZeroInteractions(mockProductRemoteDataSource);
      });

      test(
          'should return cache failure when local data source throws cache exception',
          () async {
        when(mockProductLocalDataSource.getProducts())
            .thenThrow(const CacheException(message: 'Cache Exception'));

        final result = await productRepository.getProducts();

        expect(result, const Left(CacheFailure('Cache Exception')));
      });
    });

    group('getProduct', () {
      test('should get product from local data source', () async {
        when(mockProductLocalDataSource.getProduct(tProductId))
            .thenAnswer((_) async => tProduct);

        final result = await productRepository.getProduct(tProductId);

        expect(result, const Right(tProduct));
        verify(mockProductLocalDataSource.getProduct(tProductId));
      });

      test('should not call remote data source', () async {
        await productRepository.getProduct(tProductId);

        verifyZeroInteractions(mockProductRemoteDataSource);
      });

      test(
          'should return cache failure when local data source throws cache exception',
          () async {
        when(mockProductLocalDataSource.getProduct(tProductId))
            .thenThrow(const CacheException(message: 'Cache Exception'));

        final result = await productRepository.getProduct(tProductId);

        expect(result, const Left(CacheFailure('Cache Exception')));
      });
    });

    group('createProduct', () {
      test('should return network failure', () async {
        final result = await productRepository.createProduct(tProduct);

        expect(result, const Left(NetworkFailure()));
      });
    });

    group('deleteProduct', () {
      test('should return network failure', () async {
        final result = await productRepository.deleteProduct(tProductId);

        expect(result, const Left(NetworkFailure()));
      });
    });

    group('updateProduct', () {
      test('should return network failure', () async {
        final result = await productRepository.updateProduct(tProduct);

        expect(result, const Left(NetworkFailure()));
      });
    });
  });
}