import 'dart:async';

import 'package:doc_warehouse/features/data/models/document_model.dart';

abstract class DocumentDataSource {
  Future<List<DocumentModel>> getAll();
  Future<DocumentModel> getById(int id);
  Future<int> create(DocumentModel model);
  Future<void> update(DocumentModel model);
  Future<void> deleteById(int id);
  Future<void> deleteAllById(List<int> ids);
}