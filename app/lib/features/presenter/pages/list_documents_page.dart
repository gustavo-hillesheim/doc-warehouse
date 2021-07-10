import 'package:dartz/dartz.dart' as dartz;
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/core/usecase/usecase.dart';
import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/domain/usecases/get_documents_usecase.dart';
import 'package:doc_warehouse/features/presenter/widgets/document_card.dart';
import 'package:doc_warehouse/routes.dart';
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
    _loadDocuments();
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
              (documents) => documents.isNotEmpty
                  ? DocumentsGrid(documents)
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Nenhum documento foi encontrado.'),
                          SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _add,
                            icon: Icon(Icons.add),
                            label: Text('Adicione um documento'),
                          ),
                        ],
                      ),
                    ),
            ),
      floatingActionButton: _fab(),
    );
  }

  FloatingActionButton? _fab() {
    if (result == null) {
      return null;
    }
    return result!.fold(
      (_) => null,
      (documents) => documents.isNotEmpty
          ? FloatingActionButton(
              onPressed: _add,
              child: Icon(Icons.add),
            )
          : null,
    );
  }

  void _add() {
    Modular.to.pushNamed(Routes.createDocument).then((_) => _loadDocuments());
  }

  void _loadDocuments() {
    final usecase = Modular.get<GetDocumentsUsecase>();
    usecase(NoParams()).then(
      (r) => setState(() {
        result = r;
      }),
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
        crossAxisCount: MediaQuery.of(context).size.width ~/ 120,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final document = documents.elementAt(index);
        return Padding(
          padding: EdgeInsets.all(4),
          child: Stack(children: [
            DocumentCard(document),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Modular.to.pushNamed(
                  Routes.viewDocument,
                  arguments: document,
                ),
              ),
            ),
          ]),
        );
      },
      itemCount: documents.length,
    );
  }
}
