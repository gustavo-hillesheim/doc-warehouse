import 'package:equatable/equatable.dart';

abstract class AppException extends Equatable implements Exception {

  String get message;
}

class DatabaseException extends Equatable implements AppException {

  final String message;
  final Exception? cause;

  DatabaseException(this.message, [this.cause]);

  @override
  List<Object?> get props => [message, cause];
}