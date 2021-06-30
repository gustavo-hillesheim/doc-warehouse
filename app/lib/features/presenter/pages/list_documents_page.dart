import 'package:dartz/dartz.dart' as dartz;
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/core/usecase/usecase.dart';
import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/domain/usecases/get_documents_usecase.dart';
import 'package:doc_warehouse/features/presenter/widgets/document_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ListDocumentsPage extends StatefulWidget {
  @override
  _ListDocumentsPageState createState() => _ListDocumentsPageState();
}

class _ListDocumentsPageState extends State<ListDocumentsPage> {
  dartz.Either<Failure, List<Document>>? result;

  @override
  void initState() {
    super.initState();
    Modular.get<GetDocumentsUsecase>()(NoParams()).then(
      (r) => setState(() {
        result = r;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Documentos'),
      ),
      body: result == null
          ? Center(child: CircularProgressIndicator())
          : result!.fold(
              (failure) => Center(child: Text(failure.message)),
              (documents) => DocumentsGrid(documents),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => print('navigating to create document'),
        child: Icon(Icons.add),
      ),
    );
  }
}

class DocumentsGrid extends StatelessWidget {
  final List<Document> documents;

  DocumentsGrid(this.documents);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(4),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 1),
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.all(4),
        child: Stack(children: [
          DocumentCard(documents.elementAt(index)),
          Material(
            color: Colors.transparent,
            child: InkWell(onTap: () => print('navigating to view document')),
          ),
        ]),
      ),
      itemCount: documents.length,
    );
  }
}