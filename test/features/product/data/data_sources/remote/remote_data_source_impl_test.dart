import 'dart:convert';

import 'package:ecommerce/core/constants/constants.dart';
import 'package:ecommerce/core/error/exception.dart';
import 'package:ecommerce/features/product/data/data_sources/remote/remote_data_source_impl.dart';
import 'package:ecommerce/features/product/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../../utils/fixture_reader.dart';
import 'remote_data_source_impl_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;
  late ProductRemoteDataSourceImpl productRemoteDataSource;

  setUp(() {
    mockClient = MockClient();
    productRemoteDataSource = ProductRemoteDataSourceImpl(client: mockClient);
  });

  const tProductId1 = 'acadea83-1b1b-4b1b-8b1b-1b1b1b1b1b1b';
  const tProductId2 = 'cccccc-1b1b-4b1b-8b1b-1b1b1b1b1b1b';
  const tProduct1 = ProductModel(
      id: tProductId1,
      name: 'HP Victus 15',
      description: 'Personal computer',
      price: 123.45,
      imageUrl:
          'https://www.omen.com/content/dam/sites/omen/worldwide/laptops/2022-victus-15-intel/Hero%20Image%203.png');
  const tProduct2 = ProductModel(
      id: tProductId2,
      name: 'Lenovo Legion 5',
      description: 'Personal computer',
      price: 123.45,
      imageUrl:
          'https://www.omen.com/content/dam/sites/omen/worldwide/laptops/2022-victus-15-intel/Hero%20Image%203.png');

  const tProducts = [tProduct1, tProduct2];

  final tProductsFixture = fixture('product_list.json');
  final tProduct1Fixture = jsonEncode(jsonDecode(fixture('product.json')));

  group('getProducts', () {
    test('should return list of products when the response code is 200',
        () async {
      when(mockClient.get(Uri.parse('$baseUrl/products')))
          .thenAnswer((_) async => http.Response(tProductsFixture, 200));

      final result = await productRemoteDataSource.getProducts();

      expect(result, tProducts);
    });

    test('should throw ServerException when the response code is not 200',
        () async {
      when(mockClient.get(Uri.parse('$baseUrl/products')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = productRemoteDataSource.getProducts;

      expect(() => call(), throwsA(isA<ServerException>()));
    });
  });

  group('getProduct', () {
    test('should return product when the response code is 200', () async {
      when(mockClient.get(Uri.parse('$baseUrl/products/$tProductId1')))
          .thenAnswer((_) async => http.Response(tProduct1Fixture, 200));

      final result = await productRemoteDataSource.getProduct(tProductId1);

      expect(result, tProduct1);
    });

    test('should throw ServerException when the response code is not 200',
        () async {
      when(mockClient.get(Uri.parse('$baseUrl/products/$tProductId1')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = productRemoteDataSource.getProduct;

      expect(() => call(tProductId1), throwsA(isA<ServerException>()));
    });
  });

  group('createProduct', () {
    test('should return product when the response code is 201', () async {
      when(mockClient.post(Uri.parse('$baseUrl/products'),
              headers: defaultHeaders, body: jsonEncode(tProduct1.toJson())))
          .thenAnswer((_) async => http.Response(tProduct1Fixture, 201));

      final result = await productRemoteDataSource.createProduct(tProduct1);

      expect(result, tProduct1);
    });

    test('should throw ServerException when the response code is not 201',
        () async {
      when(mockClient.post(Uri.parse('$baseUrl/products'),
              headers: defaultHeaders, body: jsonEncode(tProduct1.toJson())))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = productRemoteDataSource.createProduct;

      expect(() => call(tProduct1), throwsA(isA<ServerException>()));
    });
  });

  group('updateProduct', () {
    test('should return product when the response code is 200', () async {
      when(mockClient.put(Uri.parse('$baseUrl/products/$tProductId1'),
              headers: defaultHeaders, body: jsonEncode(tProduct1.toJson())))
          .thenAnswer((_) async => http.Response(tProduct1Fixture, 200));

      final result = await productRemoteDataSource.updateProduct(tProduct1);

      expect(result, tProduct1);
    });

    test('should throw ServerException when the response code is not 200',
        () async {
      when(mockClient.put(Uri.parse('$baseUrl/products/$tProductId1'),
              headers: defaultHeaders, body: jsonEncode(tProduct1.toJson())))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = productRemoteDataSource.updateProduct;

      expect(() => call(tProduct1), throwsA(isA<ServerException>()));
    });
  });

  group('deleteProduct', () {
    test('should make delete request', () async {
      when(mockClient.delete(Uri.parse('$baseUrl/products/$tProductId1')))
          .thenAnswer((_) async => http.Response(tProduct1Fixture, 200));

      await productRemoteDataSource.deleteProduct(tProductId1);

      verify(mockClient.delete(Uri.parse('$baseUrl/products/$tProductId1')))
          .called(1);
    });

    test('should throw ServerException when the response code is not 200',
        () async {
      when(mockClient.delete(Uri.parse('$baseUrl/products/$tProductId1')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = productRemoteDataSource.deleteProduct;

      expect(() => call(tProductId1), throwsA(isA<ServerException>()));
    });
  });
}