import 'package:dartz/dartz.dart';
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/core/usecase/usecase.dart';
import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/domain/repository/document_repository.dart';

class DeleteDocumentsUseCase extends UseCase<List<Document>, void> {
  final DocumentRepository repository;

  DeleteDocumentsUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(List<Document> documents) async {
    return repository.deleteAll(documents);
  }
}
