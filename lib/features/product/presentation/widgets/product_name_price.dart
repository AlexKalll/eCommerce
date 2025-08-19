import 'package:flutter/material.dart';

class ProductNamePrice extends StatelessWidget {
  final String name;
  final double price;

  const ProductNamePrice({super.key, required this.name, required this.price});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name, style: Theme.of(context).textTheme.titleLarge),
        Text(
          '\$${price.toString()}',
        ),
      ],
    );
  }
}