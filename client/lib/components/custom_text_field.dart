import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.textEditingController,
      required this.hintText,
      this.suffixIcon});
  final TextEditingController textEditingController;
  final String hintText;
  final Widget? suffixIcon;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: hintText,
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
        filled: true,
        fillColor: const Color.fromARGB(255, 214, 214, 214),
      ),
    );
  }
}
