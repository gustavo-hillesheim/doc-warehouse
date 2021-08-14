import 'package:flutter_modular/flutter_modular.dart';

class Routes {

  Routes._();

  static final splashScreen = Modular.initialRoute;
  static final listDocuments = '/listDocuments';
  static final createDocument = '/createDocument';
  static final editDocument = '/editDocument';
  static final viewDocument = '/viewDocument';
  static final saveSharedDocument = '/saveSharedDocument';
}