import 'package:dartz/dartz.dart';
import 'package:doc_warehouse/core/errors/exceptions.dart';
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/features/data/datasource/document_datasource.dart';
import 'package:doc_warehouse/features/data/models/document_model.dart';
import 'package:doc_warehouse/features/data/repository/document_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late DocumentRepositoryImpl repository;
  late DocumentDatasource datasource;

  setUp(() {
    datasource = MockDocumentDatasource();
    repository = DocumentRepositoryImpl(datasource);
  });

  test('should return Document model when calling datasource', () async {
    when(datasource.getDocuments).thenAnswer((_) async => mockDocumentsModel);

    final result = await repository.getDocuments();

    expect(result, Right(mockDocumentsModel));
    verify(datasource.getDocuments).called(1);
  });

  test('should return ServerFailure on exception', () async {
    when(datasource.getDocuments).thenThrow(ServerException());

    final result = await repository.getDocuments();

    expect(result, Left(ServerFailure()));
    verify(datasource.getDocuments).called(1);
  });
}

final mockDocumentsModel = [
  DocumentModel(
    name: 'Test Document',
    filePath: 'document.txt',
    creationTime: DateTime(2020, 5, 15)
  ),
];

class MockDocumentDatasource extends Mock implements DocumentDatasource {}
