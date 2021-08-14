import 'package:doc_warehouse/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.blueGrey;
    return MaterialApp(
      initialRoute: Routes.splashScreen,
      theme: ThemeData(
        primarySwatch: primaryColor,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: _inputDecorationTheme(primaryColor),
      ),
      home: Center(
        child: Text('This is the splash screen'),
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
