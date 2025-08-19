import 'dart:convert';
import 'package:ecommerce/core/error/exception.dart';
import 'package:ecommerce/features/product/data/data_sources/local/local_data_source_impl.dart';
import 'package:ecommerce/features/product/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../utils/fixture_reader.dart';
import 'local_data_source_impl_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late MockSharedPreferences mockSharedPreferences;
  late ProductLocalDataSourceImpl productLocalDataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    productLocalDataSource =
        ProductLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
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

  group('cacheProduct', () {
    test('should call setString of shared preferences', () async {
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);

      await productLocalDataSource.cacheProduct(tProduct1);

      verify(mockSharedPreferences.setString(any, any));
    });
  });

  group('cacheProducts', () {
    test('should call setString of shared preferences', () async {
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);

      await productLocalDataSource.cacheProducts(tProducts);

      verify(mockSharedPreferences.setString(any, any));
    });
  });

  group('getProduct', () {
    test('should return ProductModel from shared preferences', () async {
      when(mockSharedPreferences.getString(any)).thenReturn(tProduct1Fixture);

      final result = await productLocalDataSource.getProduct(tProductId1);

      expect(result, tProduct1);
    });

    test('should throw CacheException when product not found', () async {
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      final call = productLocalDataSource.getProduct;

      expect(() => call(tProductId1),
          throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('getProducts', () {
    test('should return List<ProductModel> from shared preferences', () async {
      when(mockSharedPreferences.getString(any)).thenReturn(tProductsFixture);

      final result = await productLocalDataSource.getProducts();

      expect(result, tProducts);
    });

    test('should throw CacheException when products not found', () async {
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      final call = productLocalDataSource.getProducts;

      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('deleteProduct', () {
    test('should call remove of shared preferences', () async {
      when(mockSharedPreferences.remove(any)).thenAnswer((_) async => true);

      await productLocalDataSource.deleteProduct(tProductId1);

      verify(mockSharedPreferences.remove(any));
    });
  });
}