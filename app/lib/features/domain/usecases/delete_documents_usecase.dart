import 'package:dartz/dartz.dart';
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/core/usecase/usecase.dart';
import 'package:doc_warehouse/core/utils/file_deleter.dart';
import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/domain/repository/document_repository.dart';

class DeleteDocumentsUseCase extends UseCase<List<Document>, void> {
  final DocumentRepository repository;
  final FileDeleter fileDeleter;

  DeleteDocumentsUseCase(this.repository, this.fileDeleter);

  @override
  Future<Either<Failure, void>> call(List<Document> documents) async {
    final result = await repository.deleteAll(documents);
    if (result.isRight()) {
      await fileDeleter.deleteAll(documents.map((doc) => doc.filePath).toList());
    }
    return result;
  }
}
