import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.blueGrey;
    return MaterialApp(
      initialRoute: '/',
      theme: ThemeData(
        primarySwatch: primaryColor,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: _inputDecorationTheme(primaryColor),
      ),
    ).modular();
  }

  InputDecorationTheme _inputDecorationTheme(MaterialColor primaryColor) {
    final border = UnderlineInputBorder(
      borderSide: BorderSide(
        color: primaryColor.withOpacity(0.2),
        width: 2,
      ),
    );
    return InputDecorationTheme(
      border: border,
      alignLabelWithHint: true,
      focusedBorder: border.copyWith(
        borderSide: border.borderSide.copyWith(
          color: primaryColor.withOpacity(0.4),
        ),
      ),
      focusColor: primaryColor.withOpacity(0.2),
    );
  }
}
