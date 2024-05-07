import 'package:flutter/material.dart';

class BlogEditor extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const BlogEditor({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        maxLines: null,
        controller: controller,
        validator: (value) => value!.isEmpty ? 'Please enter $hintText' : null,
        decoration: InputDecoration(
          hintText: hintText,
        ));
  }
}
