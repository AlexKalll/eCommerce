import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/routes/app_routes.dart';
import '../../../../core/presentation/widgets/snackbar.dart';
import '../../domain/entities/product.dart';
import '../bloc/product/product_bloc.dart';
import '../widgets/product_form.dart';

class UpdateProductPage extends StatelessWidget {
  final Product product;

  const UpdateProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductsBloc, ProductsState>(
      listener: (context, state) {
        if (state is ProductsUpdateSuccess) {
          context.go(Routes.home);
          showInfo(context, 'Product updated successfully');
        }
      },
      child: Scaffold(
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
      ),
    );
  }
}