import 'package:dartz/dartz.dart';
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/core/usecase/usecase.dart';
import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/domain/repository/document_repository.dart';

class CreateDocumentUsecase extends Usecase<Document, Document> {
  final DocumentRepository repository;

  CreateDocumentUsecase(this.repository);

  @override
  Future<Either<Failure, Document>> call(Document document) {
    return repository.create(document);
  }
}