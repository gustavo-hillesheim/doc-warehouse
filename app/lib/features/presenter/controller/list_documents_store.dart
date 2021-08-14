import 'package:dartz/dartz.dart';
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/domain/usecases/get_documents_usecase.dart';
import 'package:flutter_triple/flutter_triple.dart';

class ListDocumentsStore extends NotifierStore<Failure, List<Document>> {
  final GetDocumentsUseCase usecase;

  ListDocumentsStore(this.usecase) : super([]);

  Future<void> loadDocuments([String? name]) async {
    executeEither(() async {
      return MyEitherAdapter(await usecase(DocumentFilter(name: name)));
    }, delay: Duration(milliseconds: name != null ? 300 : 0));
  }
}

class MyEitherAdapter<Left, Right> extends EitherAdapter<Left, Right> {
  final Either<Left, Right> either;

  MyEitherAdapter(this.either);

  @override
  fold(Function(Left l) leftF, Function(Right l) rightF) {
    return either.fold(leftF, rightF);
  }
}
