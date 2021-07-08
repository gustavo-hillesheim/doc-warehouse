library app_database;

import 'package:sqflite/sqflite.dart';

part 'app_database_impl.dart';

class AppDatabaseFactory {
  static AppDatabase? _instance;

  static Future<AppDatabase> getInstance() async {
    if (_instance == null) {
      _instance = _AppDatabaseImpl();
      await _instance!.init();
    }
    return _instance!;
  }
}

abstract class AppDatabase {
  Future<void> init();
  Future<QueryResult<List<Map<String, dynamic>>>> query(String sql, [List<dynamic>? params]);
  Future<InsertResult<int>> insert(String sql, [List<dynamic>? params]);
}

class QueryResult<T> {
  final T data;

  QueryResult(this.data);
}

class InsertResult<T> {
  final T id;

  InsertResult({required this.id});
}