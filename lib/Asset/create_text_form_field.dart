import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../const.dart';

class CreateTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? initialValue;
  final String? Function(String?)? validator;
  final void Function(PointerDownEvent)? onTapOutside;
  final void Function(String?)? onChanged;
  final IconButton? suffixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatter;
  final bool? obscureText;
  final void Function()? onTap;
  final Widget? prefix;
  final bool? enabled;

  const CreateTextFormField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.initialValue,
    this.validator,
    this.onTapOutside,
    this.onChanged,
    this.suffixIcon,
    this.keyboardType,
    this.inputFormatter,
    this.obscureText,
    this.onTap,
    this.enabled,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefix: prefix,
        suffixIcon: suffixIcon,
        filled: enabled == false ? true : false,
        fillColor: enabled == false ? disabledColor : null,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: accentColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: accentColor),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: errorTextColor),
        ),
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatter,
      initialValue: initialValue,
      autovalidateMode: AutovalidateMode.always,
      validator: validator,
      onChanged: onChanged,
      onTapOutside: onTapOutside,
      onTap: onTap,
      obscureText: obscureText ?? false,
      enabled: enabled ?? true,
    );
  }
}
