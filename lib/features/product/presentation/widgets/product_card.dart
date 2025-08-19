import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';
import 'product_description_rating.dart';
import 'product_name_price.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Function(Product) onProductSelected;

  const ProductCard(
      {super.key, required this.product, required this.onProductSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onProductSelected(product);
      },
      child: Card(
        child: Column(
          children: <Widget>[
            // Image
            SizedBox(
              height: 150,
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),

            // Product Details
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ProductNamePrice(name: product.name, price: product.price),
                    const SizedBox(height: 10),

                    //
                    ProductDescriptionRating(
                      description: product.description,
                      rating: '4.5',
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}