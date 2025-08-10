import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/error/exception.dart';
import '../../models/product_model.dart';
import 'local_data_source.dart';

class ProductLocalDataSourceImpl extends ProductLocalDataSource {
  final productCacheKey = 'PRODUCTS';

  final SharedPreferences _sharedPreferences;

  ProductLocalDataSourceImpl({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  _getProductCacheKey(String id) => '${productCacheKey}_$id';

  @override
  Future<void> cacheProduct(ProductModel product) async {
    await _sharedPreferences.setString(
      _getProductCacheKey(product.id),
      jsonEncode(product.toJson()),
    );
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    await _sharedPreferences.setString(
      productCacheKey,
      jsonEncode(products.map((e) => e.toJson()).toList()),
    );
  }

  @override
  Future<void> deleteProduct(String id) {
    return _sharedPreferences.remove(_getProductCacheKey(id));
  }

  @override
  Future<ProductModel> getProduct(String id) async {
    final productJson = _sharedPreferences.getString(_getProductCacheKey(id));
    if (productJson != null) {
      return ProductModel.fromJson(jsonDecode(productJson));
    } else {
      throw const CacheException(message: 'Product not found in cache');
    }
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    final productsJson = _sharedPreferences.getString(productCacheKey);
    if (productsJson != null) {
      return (jsonDecode(productsJson) as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
    } else {
      throw const CacheException(message: 'Products not found in cache');
    }
  }
}