import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/button.dart';
import '../../../../core/presentation/widgets/image_input.dart';
import '../../../../core/presentation/widgets/input.dart';
import '../../../../core/presentation/widgets/snackbar.dart';
import '../../domain/entities/product.dart';

class ProductForm extends StatefulWidget {
  final Product? product;

  const ProductForm({super.key, this.product});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _priceController.text = widget.product!.price.toString();
      _descriptionController.text = widget.product!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ImageInput(
            defaultImageUrl: widget.product?.imageUrl,
            onImagePicked: (pickedImage) {
              setState(() {
                _pickedImage = pickedImage;
              });
            },
          ),
          const SizedBox(height: 10),
          Input(
            label: 'Name',
            controller: _nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              Input(
                  label: 'Price',
                  controller: _priceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  }),
              const Positioned(
                top: 38,
                right: 10,
                child: Icon(
                  Icons.attach_money,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Input(
            label: 'Description',
            controller: _descriptionController,
            isMultiline: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),

          //
          SizedBox(
            width: double.infinity,
            child: Button(
              text: widget.product != null ? 'Update' : 'Add',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_pickedImage == null && widget.product == null) {
                    showError(context, 'Please select an image');
                    return;
                  }
                  // Save product
                }
              },
            ),
          )
        ],
      ),
    );
  }
}