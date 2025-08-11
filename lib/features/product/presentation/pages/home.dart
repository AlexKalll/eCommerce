import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/routes/routes.dart';
import '../../domain/entities/product.dart';
import '../widgets/widgets.dart';

class HomePage extends StatelessWidget {
  final products = const [
    Product(
        id: 'id',
        name: 'HP Victus',
        description: 'Personal Computer',
        price: 123.45,
        imageUrl:
            'https://www.omen.com/content/dam/sites/omen/worldwide/laptops/2022-victus-15-intel/Hero%20Image%203.png'),
    Product(
        id: 'id',
        name: 'HP Victus 16',
        description: 'Gaming Laptop',
        price: 123.45,
        imageUrl:
            'https://www.omen.com/content/dam/sites/omen/worldwide/laptops/2022-victus-15-intel/Hero%20Image%203.png'),
    Product(
        id: 'id',
        name: 'HP Victus 16',
        description: 'Gaming Laptop',
        price: 123.45,
        imageUrl:
            'https://www.omen.com/content/dam/sites/omen/worldwide/laptops/2022-victus-15-intel/Hero%20Image%203.png'),
    Product(
        id: 'id',
        name: 'HP Victus 16',
        description: 'Gaming Laptop',
        price: 123.45,
        imageUrl:
            'https://www.omen.com/content/dam/sites/omen/worldwide/laptops/2022-victus-15-intel/Hero%20Image%203.png'),
  ];
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return ProductCard(
                        product: product,
                        onProductSelected: (product) {
                          context.push(Routes.productDetail, extra: product);
                        });
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
    );
  }
}