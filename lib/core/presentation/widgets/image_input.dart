import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  final String? defaultImageUrl;

  final void Function(File pickedImage) onImagePicked;

  const ImageInput(
      {super.key, required this.onImagePicked, this.defaultImageUrl});

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  XFile? _pickedImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            final pickedImage =
                await ImagePicker().pickImage(source: ImageSource.gallery);
            setState(() {
              _pickedImage = pickedImage;
              if (pickedImage != null) {
                widget.onImagePicked(File(pickedImage.path));
              }
            });
          },
          child: Container(
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 234, 233, 233),
            ),
            child: _pickedImage == null
                ? widget.defaultImageUrl == null
                    ? const Center(child: Text('Upload image'))
                    : Image.network(widget.defaultImageUrl!)
                : Image.file(File(_pickedImage!.path), fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}