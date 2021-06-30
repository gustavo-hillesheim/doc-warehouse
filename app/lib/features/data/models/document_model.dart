import 'package:doc_warehouse/features/domain/entities/document.dart';

class DocumentModel extends Document {
  DocumentModel({
    int? id,
    required String name,
    required String filePath,
    required DateTime creationTime,
    String? description,
  }) : super(
          id: id,
          name: name,
          filePath: filePath,
          creationTime: creationTime,
          description: description,
        );

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'],
      name: json['name'],
      filePath: json['filePath'],
      creationTime: DateTime.parse(json['creationTime']),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'filePath': filePath,
    'creationTime': creationTime.toString(),
    'description': description,
  };
}
