import 'package:dartz/dartz.dart';
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/core/usecase/usecase.dart';
import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/domain/repository/document_repository.dart';

class GetDocumentsUseCase extends UseCase<DocumentFilter, List<Document>> {
  final DocumentRepository repository;

  GetDocumentsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Document>>> call(DocumentFilter filter) {
    return repository.getAll(name: filter.name);
  }
}

class DocumentFilter {
  final String? name;

  DocumentFilter({this.name});
}