import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/error/exception.dart';
import '../../models/product_model.dart';
import 'remote_data_source.dart';

class ProductRemoteDataSourceImpl extends ProductRemoteDataSource {
  final http.Client client;
  final String _baseUrl;

  ProductRemoteDataSourceImpl({
    required this.client,
  }) : _baseUrl = '$baseUrl/products';

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(_baseUrl));
      request.fields.addAll({
        'name': product.name,
        'description': product.description,
        'price': product.price.toString()
      });

      request.files.add(await http.MultipartFile.fromPath(
        'image',
        product.imageUrl,
        contentType: MediaType('image', 'jpeg'),
      ));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        final result = await response.stream.bytesToString();

        return ProductModel.fromJson(jsonDecode(result)['data']);
      } else {
        throw ServerException(
            message: response.reasonPhrase ?? 'Error occurred while uploading');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      final response = await client.delete(Uri.parse('$_baseUrl/$id'));

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
      final response = await client.get(Uri.parse('$_baseUrl/$id'));

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
      final response = await client.get(Uri.parse(_baseUrl));

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
      final response = await client.put(Uri.parse('$_baseUrl/${product.id}'),
          body: jsonEncode(product.toJson()), headers: defaultHeaders);

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