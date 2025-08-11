import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';
import '../widgets/product_form.dart';

class UpdateProductPage extends StatelessWidget {
  final Product product;

  const UpdateProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
            child: ProductForm(
          product: product,
        )),
      ),
    );
  }
}