import 'package:flutter/material.dart';

abstract class BaseConstant {
  /// app font families
  static const String nunitoSansBold = 'Nunito_Bold';
  static const String nunitoSansSemibold = 'Nunito_Semi_Bold';
  static const String nunitoSansRegular = 'Nunito_Regular';
  static const String nunitoSansLight = 'Nunito_Light';

  abstract Color colorSurface;
  abstract Color colorOnSurface;
  abstract Color colorBackground;
  abstract Color colorOnBackground;

  Color colorPrimary = const Color(0xFF1568C8);
  Color colorOnPrimary = Colors.white;
  Color colorSecondary = const Color(0xff1FBD8D);
  Color colorOtherSecondary = const Color(0xff06A69D);
  Color colorOnSecondary = Colors.white;
  Color colorError = const Color(0xffFD787A);
  Color colorOnError = Colors.white;
}
