import 'package:dartz/dartz.dart';
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/features/domain/repository/document_repository.dart';
import 'package:doc_warehouse/features/domain/usecases/delete_document_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/document_model_mock.dart';

void main() {
  late DocumentRepository repository;
  late DeleteDocumentUsecase usecase;

  setUp(() {
    repository = MockDocumentRepository();
    usecase = DeleteDocumentUsecase(repository);
  });

  test('should call repository to delete document', () async {
    when(() => repository.deleteById(mockDocumentWithId.id!))
        .thenAnswer((_) async => Right(null));

    final result = await usecase(mockDocumentWithId);

    expect(result, Right(null));
    verify(() => repository.deleteById(mockDocumentWithId.id!)).called(1);
  });

  test('should return Business failure if document does not have id', () async {
    final result = await usecase(mockDocument);

    expect(result, Left(BusinessFailure('The document does not have an id')));
    verifyNever(() => repository.deleteById(any()));
  });

  test('should return DatabaseFailure on error on repository', () async {
    when(() => repository.deleteById(mockDocumentWithId.id!))
        .thenAnswer((_) async => Left(DatabaseFailure('fake failure')));

    final result = await usecase(mockDocumentWithId);

    expect(result, Left(DatabaseFailure('fake failure')));
    verify(() => repository.deleteById(mockDocumentWithId.id!)).called(1);
  });
}

class MockDocumentRepository extends Mock implements DocumentRepository {}
