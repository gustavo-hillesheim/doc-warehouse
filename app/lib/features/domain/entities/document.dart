import 'package:equatable/equatable.dart';

class Document extends Equatable {
  final int? id;
  final String name;
  final String? description;
  final String filePath;
  final DateTime creationTime;

  Document({
    this.id,
    required this.name,
    required this.filePath,
    required this.creationTime,
    this.description,
  });

  @override
  List<Object?> get props => [id, name, description, filePath, creationTime];
}
