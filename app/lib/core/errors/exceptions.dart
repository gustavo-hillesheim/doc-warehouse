import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  @override
  List<Object?> get props => [];
}

class DatabaseException extends Equatable implements Exception {

  final String message;
  final Exception cause;

  DatabaseException(this.message, this.cause);

  @override
  List<Object?> get props => [message, cause];
}