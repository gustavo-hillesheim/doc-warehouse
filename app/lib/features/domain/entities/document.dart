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

  Document copyWith({
    int? id,
    String? name,
    String? description,
    String? filePath,
    DateTime? creationTime,
  }) {
    return Document(
      id: id ?? this.id,
      name: name ?? this.name,
      filePath: filePath ?? this.filePath,
      creationTime: creationTime ?? this.creationTime,
      description: description ??this.description,
    );
  }

  @override
  List<Object?> get props => [id, name, description, filePath, creationTime];
}
