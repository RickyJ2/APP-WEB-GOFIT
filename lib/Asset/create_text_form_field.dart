import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../const.dart';

class CreateTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final String hintText;
  final String? initialValue;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final IconButton? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputFormatter? inputFormatter;
  final bool? obscureText;

  const CreateTextFormField({
    super.key,
    this.controller,
    required this.labelText,
    required this.hintText,
    this.initialValue,
    required this.validator,
    required this.onChanged,
    this.suffixIcon,
    this.keyboardType,
    this.inputFormatter,
    this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: accentColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: accentColor),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatter != null ? [inputFormatter!] : null,
      initialValue: initialValue,
      autovalidateMode: AutovalidateMode.always,
      validator: validator,
      onChanged: onChanged,
      obscureText: obscureText ?? false,
    );
  }
}