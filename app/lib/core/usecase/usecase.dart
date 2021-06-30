import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:equatable/equatable.dart';

abstract class Usecase<Input, Output> {

  Future<Either<Failure, Output>> call(Input input);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}