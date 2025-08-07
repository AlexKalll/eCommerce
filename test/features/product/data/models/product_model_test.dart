import 'dart:convert';
import 'package:ecommerce/features/product/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../utils/fixture_reader.dart';

void main() {
  const tProductModel = ProductModel(
    id: 'acadea83-1b1b-4b1b-8b1b-1b1b1b1b1b1b',
    name: 'HP Victus 15',
    description: 'Personal computer',
    imageUrl:
        'https://www.omen.com/content/dam/sites/omen/worldwide/laptops/2022-victus-15-intel/Hero%20Image%203.png',
    price: 123.45,
  );

  final tProductJson = jsonDecode(fixture('product.json'));

  test('toJson should convert ProductModel to JSON', () async {
    final result = tProductModel.toJson();

    final expectedJson = tProductJson;

    expect(result, expectedJson);
  });

  test('fromJson should convert JSON to ProductModel', () async {
    final result = ProductModel.fromJson(tProductJson);

    expect(result, tProductModel);
  });
}