import 'package:doc_warehouse/app_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppGuard extends RouteGuard {
  AppGuard([String? guardedRoute]) : super(guardedRoute);

  @override
  Future<bool> canActivate(String path, ModularRoute router) async {
    await Modular.isModuleReady<AppModule>();
    return true;
  }
}