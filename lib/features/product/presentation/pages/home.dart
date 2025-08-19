import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/routes/routes.dart';

import '../../../../core/presentation/widgets/snackbar.dart';
import '../bloc/product/product_bloc.dart';
import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchVisible = false;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (!_isSearchVisible) {
        _searchQuery = '';
        _searchController.clear();
      }
    });
  }

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
                const UserHeader(),
                const SizedBox(height: 20),

                // Title and Search
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Available Products',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      onPressed: _toggleSearch,
                      icon: Icon(
                        _isSearchVisible ? Icons.close : Icons.search,
                        color: _isSearchVisible
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).disabledColor,
                      ),
                      iconSize: 20,
                    ),
                  ],
                ),

                // Search Bar
                if (_isSearchVisible) ...[
                  const SizedBox(height: 10),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                              icon: const Icon(Icons.clear),
                            )
                          : null,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                ],

                // Product List
                Expanded(
                  child: BlocBuilder<ProductsBloc, ProductsState>(
                    builder: (context, state) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<ProductsBloc>().add(
                            ProductsLoadRequested(),
                          );
                        },
                        child: ListView.builder(
                          itemCount: _getFilteredProducts(
                            state.products,
                          ).length,
                          itemBuilder: (context, index) {
                            final product = _getFilteredProducts(
                              state.products,
                            )[index];

                            return ProductCard(
                              product: product,
                              onProductSelected: (product) {
                                context.push(
                                  Routes.productDetail,
                                  extra: product,
                                );
                              },
                            );
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

  List<dynamic> _getFilteredProducts(List<dynamic> products) {
    if (_searchQuery.isEmpty) {
      return products;
    }

    return products.where((product) {
      final name = product.name.toString().toLowerCase();
      final description = product.description.toString().toLowerCase();
      final query = _searchQuery.toLowerCase();

      return name.contains(query) || description.contains(query);
    }).toList();
  }
}
