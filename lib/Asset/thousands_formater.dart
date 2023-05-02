import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ThousandsFormatter extends TextInputFormatter {
  static const separator = '.';

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newValueText = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    int value = int.parse(newValueText.replaceAll(separator, ''));
    String newText = NumberFormat("#,##0", "en_US").format(value);

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}

class ThousandsFormatterString {
  static String format(String value) {
    int valueInt =
        int.parse(value.replaceAll(ThousandsFormatter.separator, ''));
    return NumberFormat("#,##0", "en_US").format(valueInt);
  }
}
