import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.textEditingController,
    required this.hintText,
    this.suffixIcon,
    this.onChanged,
  });
  final TextEditingController? textEditingController;
  final String hintText;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      onChanged: onChanged,
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
