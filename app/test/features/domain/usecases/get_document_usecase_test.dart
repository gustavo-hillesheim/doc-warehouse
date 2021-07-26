import 'package:dartz/dartz.dart';
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/features/domain/repository/document_repository.dart';
import 'package:doc_warehouse/features/domain/usecases/get_document_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/document_model_mock.dart';

void main() {
  late DocumentRepository repository;
  late GetDocumentUseCase usecase;

  setUp(() {
    repository = MockDocumentRepository();
    usecase = GetDocumentUseCase(repository);
  });

  test('should call document repository with given id and return document', () async {
    when(() => repository.getById(1)).thenAnswer((_) async => Right(mockDocumentWithId));

    final result = await usecase(1);

    expect(result, Right(mockDocumentWithId));
    verify(() => repository.getById(1)).called(1);
  });

  test('should return failure on repository error', () async {
    when(() => repository.getById(1)).thenAnswer((_) async => Left(DatabaseFailure('db failure')));

    final result = await usecase(1);

    expect(result, Left(DatabaseFailure('db failure')));
    verify(() => repository.getById(1)).called(1);
  });
}

class MockDocumentRepository extends Mock implements DocumentRepository {}
