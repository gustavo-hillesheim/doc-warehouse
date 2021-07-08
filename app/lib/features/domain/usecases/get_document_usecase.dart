import 'package:dartz/dartz.dart';
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/core/usecase/usecase.dart';
import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/domain/repository/document_repository.dart';

class GetDocumentUsecase extends Usecase<int, Document> {
  final DocumentRepository repository;

  GetDocumentUsecase(this.repository);

  @override
  Future<Either<Failure, Document>> call(int id) {
    return repository.getDocument(id);
  }
}