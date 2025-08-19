import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductDescriptionRating extends StatelessWidget {
  final String description;
  final String rating;

  const ProductDescriptionRating(
      {super.key, required this.description, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: SizedBox(
            width: 100,
            child: Text(
              description,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Theme.of(context).hintColor),
            ),
          ),
        ),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.yellow, size: 20),
            Text(
              '($rating)',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Theme.of(context).hintColor),
            ),
          ],
        ),
      ],
    );
  }
}