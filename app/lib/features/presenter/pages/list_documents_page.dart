import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/presenter/widgets/document_card.dart';
import 'package:flutter/material.dart';

final mDocuments = [
  Document(
      name: 'Sample Document',
      filePath: 'file/path',
      creationTime: DateTime.now()),
  Document(
      name: 'Sample Document with long name',
      filePath: 'file/path',
      creationTime: DateTime.now()),
  Document(
      name: 'Sample Document',
      filePath: 'file/path',
      creationTime: DateTime.now()),
];

class ListDocumentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Documentos'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(4),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 1),
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.all(4),
          child: Stack(children: [
            DocumentCard(mDocuments.elementAt(index)),
            Material(
              color: Colors.transparent,
              child: InkWell(onTap: () => print('navigating to view document')),
            ),
          ]),
        ),
        itemCount: mDocuments.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => print('navigating to create document'),
        child: Icon(Icons.add),
      ),
    );
  }
}
