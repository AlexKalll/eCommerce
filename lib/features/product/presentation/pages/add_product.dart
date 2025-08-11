import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/routes/app_routes.dart';
import '../../../../core/presentation/widgets/snackbar.dart';
import '../bloc/product/product_bloc.dart';
import '../widgets/widgets.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductsBloc, ProductsState>(
      listener: (context, state) {
        if (state is ProductsAddSuccess) {
          context.go(Routes.home);
          showInfo(context, 'Product added successfully');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Product'),
        ),
        body: const Padding(
          padding: EdgeInsets.all(18),
          child: SingleChildScrollView(child: ProductForm()),
        ),
      ),
    );
  }
}