import '../../domain/entities/product.dart';
import 'product_model.dart';

// Mappers from a ProductModel to a Product entity and vice versa

extension ProductModelMapper on ProductModel {
  Product toEntity() => Product(
        id: id,
        name: name,
        description: description,
        price: price,
        imageUrl: imageUrl,
      );
}

extension ProductEntityMapper on Product {
  ProductModel toModel() => ProductModel(
        id: id,
        name: name,
        description: description,
        price: price,
        imageUrl: imageUrl,
      );
}