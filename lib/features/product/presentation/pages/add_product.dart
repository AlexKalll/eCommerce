import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(18),
        child: SingleChildScrollView(child: ProductForm()),
      ),
    );
  }
}