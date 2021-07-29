import 'package:flutter_modular/flutter_modular.dart';

class Routes {

  Routes._();

  static final listDocuments = Modular.initialRoute;
  static final createDocument = '/createDocument';
  static final editDocument = '/editDocument';
  static final viewDocument = '/viewDocument';
}