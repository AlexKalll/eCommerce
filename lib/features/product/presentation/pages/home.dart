import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/routes/routes.dart';

import '../../../../core/presentation/widgets/snackbar.dart';
import '../bloc/product/product_bloc.dart';
import '../widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductsBloc, ProductsState>(
      listener: (context, state) {
        if (state is ProductsFailure) {
          showError(context, state.message);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
            child: Column(
              children: [
                // Header
                const UserHeader(userName: 'John'),
                const SizedBox(height: 20),

                // Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Available Products',
                        style: Theme.of(context).textTheme.titleLarge),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.search,
                        color: Theme.of(context).disabledColor,
                      ),
                      iconSize: 20,
                    ),
                  ],
                ),

                // Product List
                Expanded(
                  child: BlocBuilder<ProductsBloc, ProductsState>(
                    builder: (context, state) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          context
                              .read<ProductsBloc>()
                              .add(ProductsLoadRequested());
                        },
                        child: ListView.builder(
                          itemCount: state.products.length,
                          itemBuilder: (context, index) {
                            final product = state.products[index];

                            return ProductCard(
                                product: product,
                                onProductSelected: (product) {
                                  context.push(Routes.productDetail,
                                      extra: product);
                                });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        // Floating Action Button
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.push(Routes.addProduct);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}