import 'dart:convert';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/error/exception.dart';
import '../../../../../core/network/http.dart';
import '../../models/product_model.dart';
import 'remote_data_source.dart';

class ProductRemoteDataSourceImpl extends ProductRemoteDataSource {
  final HttpClient client;
  final String _baseUrl;

  ProductRemoteDataSourceImpl({
    required this.client,
  }) : _baseUrl = '$baseUrl/products';

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    try {
      final response = await client.uploadFile(_baseUrl, HttpMethod.post, {
        'name': product.name,
        'description': product.description,
        'price': product.price.toString()
      }, [
        UploadFile(
          key: 'image',
          path: product.imageUrl,
        )
      ]);

      if (response.statusCode == 201) {
        return ProductModel.fromJson(jsonDecode(response.body)['data']);
      } else {
        throw ServerException(message: response.reasonPhrase);
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      final response = await client.delete('$_baseUrl/$id');

      if (response.statusCode != 200) {
        throw ServerException(message: response.body);
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ProductModel> getProduct(String id) async {
    try {
      final response = await client.get('$_baseUrl/$id');

      if (response.statusCode == 200) {
        return ProductModel.fromJson(jsonDecode(response.body)['data']);
      } else {
        throw ServerException(message: response.body);
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await client.get(_baseUrl);

      if (response.statusCode == 200) {
        final List<dynamic> products = jsonDecode(response.body)['data'];
        return products.map((e) => ProductModel.fromJson(e)).toList();
      } else {
        throw ServerException(message: response.body);
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    try {
      final response =
          await client.put('$_baseUrl/${product.id}', product.toJson());

      if (response.statusCode == 200) {
        return ProductModel.fromJson(jsonDecode(response.body)['data']);
      } else {
        throw ServerException(message: response.body);
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}