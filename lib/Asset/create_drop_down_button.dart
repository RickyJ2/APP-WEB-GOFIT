import 'package:flutter/material.dart';

import '../const.dart';

class CreateDropDownButton extends StatelessWidget {
  final String? label;
  final String? errorText;
  final Object value;
  final List<DropdownMenuItem<Object>> items;
  final void Function(Object?)? onChanged;

  const CreateDropDownButton({
    super.key,
    this.label,
    required this.errorText,
    required this.value,
    required this.items,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        label: label != null ? Text(label.toString()) : null,
        errorText: errorText,
        filled: onChanged == null ? true : false,
        fillColor: onChanged == null ? disabledColor : null,
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
        enabled: onChanged == null ? false : true,
        //border: InputBorder.none,
      ),
      child: DropdownButton(
        underline: Container(),
        isDense: true,
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down),
        value: value,
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}
