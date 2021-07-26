import 'package:dartz/dartz.dart';
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/domain/repository/document_repository.dart';
import 'package:doc_warehouse/features/domain/usecases/create_document_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/document_model_mock.dart';

void main() {
  late DocumentRepository repository;
  late CreateDocumentUseCase usecase;

  setUp(() {
    repository = MockDocumentRepository();
    usecase = CreateDocumentUseCase(repository);
  });

  test('should save document in repository and return created object',
      () async {
    when(() => repository.create(mockDocument))
        .thenAnswer((_) async => Right<Failure, Document>(mockDocumentWithId));

    final result = await usecase(mockDocument);

    result.fold(
      (l) => fail('Should have returned a Right'),
      (r) => expect(r, mockDocumentWithId),
    );
    verify(() => repository.create(mockDocument)).called(1);
  });

  test('should return Failure on error', () async {
    when(() => repository.create(mockDocument)).thenAnswer((_) async => Left(FakeFailure()));

    final result = await usecase(mockDocument);

    expect(result, Left(FakeFailure()));
    verify(() => repository.create(mockDocument)).called(1);
  });
}

class MockDocumentRepository extends Mock implements DocumentRepository {}

class FakeFailure extends Failure {

  final String message = 'fake message';

  @override
  List<Object?> get props => [];
}
