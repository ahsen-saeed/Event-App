import 'dart:io';
import 'dart:ui';

import 'package:event_app/main.dart';
import 'package:event_app/util/base_constants.dart';
import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  Size get mediaSize => MediaQuery.of(this).size;

  bool get isDarkTheme => Theme.of(this).brightness == Brightness.dark;

  BaseConstant get currentConstant => isDarkTheme ? darkThemeConstant : lightThemeConstant;

  bool get isHaveBottomNotch => window.viewPadding.bottom > 0 && Platform.isIOS;

  double get statusBarHeight => MediaQuery.of(this).viewPadding.top;

  double get bottomNotchHeight => MediaQuery.of(this).viewPadding.bottom;

  void unfocus() => FocusScope.of(this).unfocus();
}
