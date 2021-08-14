import 'package:doc_warehouse/app_module.dart';
import 'package:doc_warehouse/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    Modular.isModuleReady<AppModule>().then((_) {
      Modular.to.pushReplacementNamed(Routes.listDocuments);
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width * 0.33;
    return Container(
      color: Theme.of(context).primaryColor,
      child: Center(
        child: Image.asset(
          'assets/splash_screen/splash_image_gradient.png',
          width: imageSize,
          height: imageSize,
        ),
      ),
    );
  }
}
