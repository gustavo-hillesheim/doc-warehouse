library app_database;

import 'package:sqflite/sqflite.dart';

part 'app_database_impl.dart';

class AppDatabaseFactory {
  static Future<AppDatabase> createInstance() async {
    final appDatabase = _AppDatabaseImpl();
    await appDatabase.init();
    return appDatabase;
  }
}

abstract class AppDatabase {
  Future<void> init();
  Future<QueryResult<List<Map<String, dynamic>>>> query(String sql, [List<dynamic>? params]);
  Future<InsertResult<int>> insert(String sql, [List<dynamic>? params]);
  Future<void> update(String sql, [List<dynamic>? params]);
  Future<void> delete(String sql, [List<dynamic>? params]);
}

class QueryResult<T> {
  final T data;

  QueryResult(this.data);
}

class InsertResult<T> {
  final T id;

  InsertResult({required this.id});
}