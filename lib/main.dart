import 'dart:io';

import 'package:event_app/backend/backend_response.dart';
import 'package:event_app/helper/event_favourite_helper.dart';
import 'package:event_app/ui/event/event_detail_screen.dart';
import 'package:event_app/ui/event/event_detail_screen_bloc.dart';
import 'package:event_app/ui/home/home_screen.dart';
import 'package:event_app/ui/home/home_screen_bloc.dart';
import 'package:event_app/util/base_constants.dart';
import 'package:event_app/util/dark_theme_constant.dart';
import 'package:event_app/util/light_theme_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final BaseConstant darkThemeConstant = DarkThemeConstant();
final BaseConstant lightThemeConstant = LightThemeConstant();

ColorScheme get _lightColorScheme {
  return ColorScheme(
      brightness: Brightness.light,
      primary: lightThemeConstant.colorPrimary,
      onPrimary: lightThemeConstant.colorOnPrimary,
      secondary: lightThemeConstant.colorSecondary,
      onSecondary: lightThemeConstant.colorOnSecondary,
      error: lightThemeConstant.colorError,
      onError: lightThemeConstant.colorOnError,
      background: lightThemeConstant.colorBackground,
      onBackground: lightThemeConstant.colorOnBackground,
      surface: lightThemeConstant.colorSurface,
      onSurface: lightThemeConstant.colorOnSurface);
}

ColorScheme get _darkColorScheme {
  return ColorScheme(
      brightness: Brightness.dark,
      primary: darkThemeConstant.colorPrimary,
      onPrimary: darkThemeConstant.colorOnPrimary,
      secondary: darkThemeConstant.colorSecondary,
      onSecondary: darkThemeConstant.colorOnSecondary,
      error: darkThemeConstant.colorError,
      onError: darkThemeConstant.colorOnError,
      background: darkThemeConstant.colorBackground,
      onBackground: darkThemeConstant.colorOnBackground,
      surface: darkThemeConstant.colorSurface,
      onSurface: darkThemeConstant.colorOnSurface);
}

final _lightThemeData = ThemeData(brightness: Brightness.light, colorScheme: _lightColorScheme, useMaterial3: true);

final _darkThemeData = ThemeData(brightness: Brightness.dark, colorScheme: _darkColorScheme, useMaterial3: true);

class _AppRouter {
  Route _getPageRoute(Widget screen) => Platform.isIOS ? CupertinoPageRoute(builder: (_) => screen) : MaterialPageRoute(builder: (_) => screen);

  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeScreen.route:
        {
          const screen = HomeScreen();
          return _getPageRoute(BlocProvider(create: (_) => HomeScreenBloc(), child: screen));
        }
      case EventDetailScreen.route:
        {
          final event = settings.arguments as Event;
          const screen = EventDetailScreen();
          return _getPageRoute(BlocProvider(create: (_) => EventDetailScreenBloc(event: event), child: screen));
        }
    }
    return null;
  }
}

void main() {
  runApp(const _App());
  EventFavouriteHelper.initializeEventFavourites();
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    final router = _AppRouter();
    return MaterialApp(
        onGenerateRoute: router.onGenerateRoute,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        darkTheme: _darkThemeData,
        theme: _lightThemeData);
  }
}
