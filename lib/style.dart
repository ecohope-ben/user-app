import 'package:flutter/material.dart';

// const Color primaryColor = Color(0xFF030024);
// const Color accentColor = Color(0xFF851B13);

const Color lightPurple = Color(0xFFE1CDFF);
const Color purpleUnderline = Color(0xFF975DFF);
const Color mainPurple = Color(0xFF422384);
const Color backgroundColor = Color(0xFFF4F9FA);
const Color blueTextUnderline = Color(0xFF48F9FF);
const Color blueRegisterText = Color(0xFF3CA2FF);
const Color blueBorder = Color(0xFF2D5BFF);
const Color welcomeWordsBg = Color(0xFF29A862);
const Color darkGreenWord = Color(0xFF007800);
const Color lightGreenBg = Color(0xFFECFFD9);


// final primarySwatch = MaterialColor(accentColor.value, getSwatch(accentColor));

Map<int, Color> getSwatch(Color color) {
  final hslColor = HSLColor.fromColor(color);
  final lightness = hslColor.lightness;

  /// if [500] is the default color, there are at LEAST five
  /// steps below [500]. (i.e. 400, 300, 200, 100, 50.) A
  /// divisor of 5 would mean [50] is a lightness of 1.0 or
  /// a color of #ffffff. A value of six would be near white
  /// but not quite.
  final lowDivisor = 6;

  /// if [500] is the default color, there are at LEAST four
  /// steps above [500]. A divisor of 4 would mean [900] is
  /// a lightness of 0.0 or color of #000000
  final highDivisor = 5;

  final lowStep = (1.0 - lightness) / lowDivisor;
  final highStep = lightness / highDivisor;

  return {
    50: (hslColor.withLightness(lightness + (lowStep * 5))).toColor(),
    100: (hslColor.withLightness(lightness + (lowStep * 4))).toColor(),
    200: (hslColor.withLightness(lightness + (lowStep * 3))).toColor(),
    300: (hslColor.withLightness(lightness + (lowStep * 2))).toColor(),
    400: (hslColor.withLightness(lightness + lowStep)).toColor(),
    500: (hslColor.withLightness(lightness)).toColor(),
    600: (hslColor.withLightness(lightness - highStep)).toColor(),
    700: (hslColor.withLightness(lightness - (highStep * 2))).toColor(),
    800: (hslColor.withLightness(lightness - (highStep * 3))).toColor(),
    900: (hslColor.withLightness(lightness - (highStep * 4))).toColor(),
  };
}

// const MaterialColor primarySwatch = MaterialColor(
//   0xFF0D004C,
//   <int, Color>{
//     50: Color(0xFFE2E0EA),
//     100: Color(0xFFB6B3C9),
//     200: Color(0xFF8680A6),
//     300: Color(0xFF564D82),
//     400: Color(0xFF312667),
//     500: Color(0xFF0D004C),
//     600: Color(0xFF0B0045),
//     700: Color(0xFF09003C),
//     800: Color(0xFF070033),
//     900: Color(0xFF030024),
//   },
// );

// BoxDecoration bottomOverlay = BoxDecoration(
//     gradient: LinearGradient(
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//         stops: [
//       0,
//       0.8
//     ],
//         colors: [
//       primarySwatch.shade900.withAlpha(0),
//       primarySwatch.shade900.withAlpha(100),
//     ]));
// BoxDecoration rightOverlay = BoxDecoration(
//     gradient: LinearGradient(
//         begin: Alignment.centerLeft,
//         end: Alignment.centerRight,
//         stops: [
//       0,
//       0.8
//     ],
//         colors: [
//       primarySwatch.shade900.withAlpha(0),
//       primarySwatch.shade900.withAlpha(100),
//     ]));
