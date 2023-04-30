import 'package:flutter/material.dart';

import '../const.dart';

class CreateDropDownButton extends StatelessWidget {
  final String label;
  final String? errorText;
  final Object value;
  final List<DropdownMenuItem<Object>> items;
  final void Function(Object?)? onChanged;

  const CreateDropDownButton({
    super.key,
    required this.label,
    required this.errorText,
    required this.value,
    required this.items,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        label: Text(label),
        errorText: errorText,
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
