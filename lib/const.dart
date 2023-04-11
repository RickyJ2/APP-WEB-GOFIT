import 'package:flutter/material.dart';

Color primaryColor = const Color(0xFFFB8B24);
Color accentColor = const Color(0xFF131515);
Color textColor = const Color(0xFFFCF7FF);
Color textColorSecond = const Color(0xFF131515).withOpacity(0.54);
Brightness brightness = Brightness.light;

ColorScheme colorScheme = ColorScheme.fromSwatch(
  primarySwatch: MaterialColor(primaryColor.value, {
    50: Color(primaryColor.value),
    100: Color(primaryColor.value),
    200: Color(primaryColor.value),
    300: Color(primaryColor.value),
    400: Color(primaryColor.value),
    500: Color(primaryColor.value),
    600: Color(primaryColor.value),
    700: Color(primaryColor.value),
    800: Color(primaryColor.value),
    900: Color(primaryColor.value),
  }),
  accentColor: accentColor,
  brightness: brightness,
);

Text goFit = Text(
  'GoFit',
  style: TextStyle(
    fontFamily: 'SchibstedGrotesk',
    color: textColor,
    fontWeight: FontWeight.bold,
  ),
);
