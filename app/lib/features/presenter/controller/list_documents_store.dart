import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/core/usecase/usecase.dart';
import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/domain/usecases/get_documents_usecase.dart';
import 'package:flutter_triple/flutter_triple.dart';

class ListDocumentsStore extends NotifierStore<Failure, List<Document>> {
  final GetDocumentsUseCase usecase;

  ListDocumentsStore(this.usecase) : super([]);

  Future<void> loadDocuments() async {
    setLoading(true);
    final result = await usecase(NoParams());
    result.fold(
      setError,
      update,
    );
    setLoading(false);
  }
}
