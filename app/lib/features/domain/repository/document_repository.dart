import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/features/domain/entities/document.dart';

abstract class DocumentRepository {
  Future<Either<Failure, List<Document>>> getDocuments();
}
