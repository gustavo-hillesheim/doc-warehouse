import 'package:doc_warehouse/core/database/app_database.dart';
import 'package:doc_warehouse/core/errors/exceptions.dart';
import 'package:doc_warehouse/features/data/datasource/document_datasource.dart';
import 'package:doc_warehouse/features/data/models/document_model.dart';
import 'package:flutter/foundation.dart';

class DocumentDataSourceImpl extends DocumentDataSource {
  final AppDatabase database;

  DocumentDataSourceImpl(this.database);

  @override
  Future<List<DocumentModel>> getAll({String? name}) async {
    try {
      String query = "SELECT id, name, description, filePath, creationTime FROM documents";
      List queryArgs = [];
      if (name != null) {
        query += " WHERE UPPER(name) LIKE '%' || UPPER(?) || '%'";
        queryArgs.add(name);
      }
      final queryResult = await database.query(query, queryArgs);
      return queryResult.data
          .map((json) => DocumentModel.fromJson(json))
          .toList(growable: false);
    } on Exception catch (e) {
      debugPrint('Error on querying documents: $e');
      throw DatabaseException("Could not query documents", e);
    }
  }

  @override
  Future<int> create(DocumentModel model) async {
    try {
      final insertResult = await database.insert(
        "INSERT INTO documents (name, description, "
        "filePath, creationTime) VALUES (?, ?, ?, ?)",
        [
          model.name,
          model.description,
          model.filePath,
          model.creationTime.toIso8601String()
        ],
      );
      return insertResult.id;
    } on Exception catch (e) {
      throw DatabaseException("Could not insert document", e);
    }
  }

  @override
  Future<void> update(DocumentModel model) async {
    try {
      await database.update(
        "UPDATE documents "
        "SET name = ?, description = ?, filePath = ?, creationTime = ? "
        "WHERE id = ?",
        [
          model.name,
          model.description,
          model.filePath,
          model.creationTime.toIso8601String(),
          model.id,
        ],
      );
    } on Exception catch (e) {
      throw DatabaseException("Could not update document", e);
    }
  }

  @override
  Future<DocumentModel> getById(int id) async {
    try {
      final queryResult = await database.query(
          "SELECT id, name, description, filePath, creationTime "
          "FROM documents WHERE id = ?",
          [id]);
      if (queryResult.data.isEmpty) {
        throw DatabaseException("Could not find document with id $id");
      }
      return DocumentModel.fromJson(queryResult.data.first);
    } on Exception catch (e) {
      throw DatabaseException("Could not query document with id $id", e);
    }
  }

  @override
  Future<void> deleteById(int id) async {
    try {
      await database.delete("DELETE FROM documents WHERE id = ?", [id]);
    } on Exception catch (e) {
      throw DatabaseException("Could not delete document with id $id", e);
    }
  }

  @override
  Future<void> deleteAllById(List<int> ids) async {
    try {
      final idsPlaceholder = List.filled(ids.length, '?').join(', ');
      await database.delete(
          "DELETE FROM documents WHERE id IN ($idsPlaceholder)", ids);
    } on Exception catch (e) {
      throw DatabaseException("Could not delete documents with ids $ids", e);
    }
  }

  @override
  Future<int> getNextId() async {
    try {
      final result =
          await database.query("SELECT seq + 1 as nextId FROM sqlite_sequence where "
              "name='documents'");
      if (result.data.isNotEmpty) {
        return result.data.first['nextId'];
      } else {
        return 1;
      }
    } on Exception catch (e) {
      throw DatabaseException("Could not query next id", e);
    }
  }
}
