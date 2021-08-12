import 'package:dartz/dartz.dart';
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/core/utils/file_deleter.dart';
import 'package:doc_warehouse/features/domain/repository/document_repository.dart';
import 'package:doc_warehouse/features/domain/usecases/delete_documents_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/document_model_mock.dart';

void main() {
  late FileDeleter fileDeleter;
  late DocumentRepository repository;
  late DeleteDocumentsUseCase usecase;

  setUp(() {
    fileDeleter = MockFileDeleter();
    repository = MockDocumentRepository();
    usecase = DeleteDocumentsUseCase(repository, fileDeleter);
  });

  test('should delete all specified documents', () async {
    when(() => fileDeleter.deleteAll(any())).thenAnswer((_) async {});
    when(() => repository.deleteAll(any())).thenAnswer((_) async => Right(null));

    final documentToDelete = [
      mockDocumentWithId.copyWith(id: 1),
      mockDocumentWithId.copyWith(id: 2)
    ];
    final result = await usecase(documentToDelete);

    expect(result, Right(null));
    verify(() => repository.deleteAll(documentToDelete)).called(1);
  });

  test('should return Failure if repository returns failure', () async {
    when(() => repository.deleteAll(any())).thenAnswer((_) async => left(FakeFailure('fake message')));

    final result = await usecase([
      mockDocumentWithId.copyWith(id: 1),
      mockDocumentWithId.copyWith(id: 2)
    ]);

    expect(result, Left(FakeFailure('fake message')));
  });
}

class MockDocumentRepository extends Mock implements DocumentRepository {}

class MockFileDeleter extends Mock implements FileDeleter {}

class FakeFailure extends Failure {
  final String message;

  FakeFailure(this.message);

  @override
  List<Object?> get props => [message];
}
