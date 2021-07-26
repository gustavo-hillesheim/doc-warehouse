import 'package:dartz/dartz.dart';
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/core/usecase/usecase.dart';
import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/domain/repository/document_repository.dart';

class DeleteDocumentUseCase extends UseCase<Document, void> {
  final DocumentRepository repository;

  DeleteDocumentUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Document document) {
    if (document.id == null) {
      return Future.value(Left(BusinessFailure('The document does not have an id')));
    }
    return repository.deleteById(document.id!);
  }
}