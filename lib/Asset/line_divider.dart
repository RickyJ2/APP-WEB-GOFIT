import 'package:flutter/material.dart';
import '../const.dart';

class LineDivider extends StatelessWidget {
  const LineDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: primaryColor,
      thickness: 3.0,
      endIndent: 340,
    );
  }
}
