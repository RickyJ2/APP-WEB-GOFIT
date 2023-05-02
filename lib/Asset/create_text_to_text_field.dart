import 'package:flutter/material.dart';

import '../const.dart';

class CreateTextToTextField extends StatelessWidget {
  final String label;
  final Widget textField;
  final int? textFlex;
  final int? textFieldFlex;
  const CreateTextToTextField({
    super.key,
    required this.label,
    required this.textField,
    this.textFlex,
    this.textFieldFlex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: textFlex ?? 1,
          child: Text(
            '$label : ',
            style: TextStyle(
              fontFamily: 'robot',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
        ),
        Flexible(
          flex: textFieldFlex ?? 3,
          child: textField,
        ),
      ],
    );
  }
}
