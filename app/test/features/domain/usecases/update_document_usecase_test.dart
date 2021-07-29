import 'package:dartz/dartz.dart';
import 'package:doc_warehouse/features/domain/repository/document_repository.dart';
import 'package:doc_warehouse/features/domain/usecases/update_document_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/document_model_mock.dart';

void main() {
  late UpdateDocumentUseCase usecase;
  late DocumentRepository repository;

  setUp(() {
    repository = MockDocumentRepository();
    usecase = UpdateDocumentUseCase(repository);
  });

  test('Should call repository to update Document', () async {
    when(() => repository.update(mockDocumentWithId)).thenAnswer((_) async => Right(mockDocumentWithId));

    final result = await usecase(mockDocumentWithId);

    expect(result, Right(mockDocumentWithId));
    verify(() => repository.update(mockDocumentWithId)).called(1);
  });
}

class MockDocumentRepository extends Mock implements DocumentRepository {}