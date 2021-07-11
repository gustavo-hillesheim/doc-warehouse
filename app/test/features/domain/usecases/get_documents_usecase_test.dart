import 'package:dartz/dartz.dart';
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/core/usecase/usecase.dart';
import 'package:doc_warehouse/features/domain/repository/document_repository.dart';
import 'package:doc_warehouse/features/domain/usecases/get_documents_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/document_model_mock.dart';

void main() {
  late GetDocumentsUsecase usecase;
  late DocumentRepository repository;

  setUp(() {
    repository = MockDocumentRepository();
    usecase = GetDocumentsUsecase(repository);
  });

  test('should return list of documents', () async {
    when(repository.getAll).thenAnswer((_) async => Right(mockDocuments));

    final result = await usecase(NoParams());

    expect(result, equals(Right(mockDocuments)));
    verify(repository.getAll).called(1);
  });

  test('should return Failure on error', () async {
    when(repository.getAll).thenAnswer((_) async => Left(FakeFailure()));

    final result = await usecase(NoParams());

    expect(result, Left(FakeFailure()));
    verify(repository.getAll).called(1);
  });
}

class FakeFailure extends Failure {

  final String message = 'fake message';

  @override
  List<Object?> get props => [];
}
class MockDocumentRepository extends Mock implements DocumentRepository {}
