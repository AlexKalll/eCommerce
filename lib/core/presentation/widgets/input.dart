import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  const Input({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.maxLines,
    this.keyboardType,
    this.validator,
    this.isPassword = false,
    this.isMultiline = false,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final bool isPassword;
  final bool isMultiline;
  final int? maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(label),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          maxLines: maxLines ?? (isMultiline ? 5 : 1),
          keyboardType: keyboardType ??
              (isMultiline ? TextInputType.multiline : TextInputType.text),
          validator: validator,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.symmetric(
                vertical: isMultiline ? 10 : 2, horizontal: 10),
            focusColor: Theme.of(context).colorScheme.primary,
            labelStyle: const TextStyle(color: Colors.grey),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}