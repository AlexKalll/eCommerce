import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/routes/routes.dart';
import '../../../../core/presentation/widgets/snackbar.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../domain/entities/product.dart';
import '../bloc/product/product_bloc.dart';
import '../widgets/widgets.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductsBloc, ProductsState>(
      listener: (context, state) {
        if (state is ProductsDeleteSuccess) {
          context.go(Routes.home);
          showInfo(context, 'Product deleted successfully');
        }
      },
      child: Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              Center(
                child: CachedNetworkImage(
                  height: 300,
                  imageUrl: product.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                ),
              ),
              Positioned(
                top: 20,
                left: 0,
                child: IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
            ],
          ),

          //

          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Heading
                Column(
                  children: [
                    // Description and rating
                    ProductDescriptionRating(
                      description: product.description,
                      rating: '4.5',
                    ),

                    const SizedBox(height: 10),

                    // Name and price
                    ProductNamePrice(
                      name: product.name,
                      price: product.price,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Description
                SizedBox(
                  height: 400,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Text(
                      product.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                    ),
                  ),
                ),

                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Button(
                      onPressed: () => _deleteProduct(context),
                      color: Colors.red,
                      text: 'Delete',
                    ),
                    Button(
                      onPressed: () {
                        context.push(Routes.updateProduct, extra: product);
                      },
                      color: Theme.of(context).primaryColor,
                      text: 'Update',
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      )),
    );
  }

  //
  void _deleteProduct(BuildContext context) {
    // Delete
    context.read<ProductsBloc>().add(
          ProductsProductDeleted(product),
        );
  }
}