import 'package:flutter/material.dart';

// Barvy
ColorScheme cScheme = ColorScheme(
  brightness: Brightness.light,
  primary: primary,
  onPrimary: background,
  secondary: secondary,
  onSecondary: primary,
  tertiary: tertiary,
  onTertiary: primary,
  error: cRed,
  onError: primary,
  surface: background,
  onSurface: primary,
);

Color background = const Color.fromRGBO(219, 245, 240, 1.0);
Color tertiary = const Color.fromRGBO(164, 229, 224, 1.0);
Color secondary = const Color.fromRGBO(55, 190, 176, 1.0);
Color primary = const Color.fromRGBO(12, 97, 112, 1.0);
Color cRed = const Color.fromRGBO(237, 69, 69, 1.0);
