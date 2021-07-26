import 'package:dartz/dartz.dart' as dartz;
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/core/usecase/usecase.dart';
import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/domain/usecases/delete_document_usecase.dart';
import 'package:doc_warehouse/features/domain/usecases/get_documents_usecase.dart';
import 'package:doc_warehouse/features/presenter/widgets/custom_checkbox.dart';
import 'package:doc_warehouse/features/presenter/widgets/documents_grid.dart';
import 'package:doc_warehouse/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ListDocumentsPage extends StatefulWidget {
  @override
  _ListDocumentsPageState createState() => _ListDocumentsPageState();
}

class _ListDocumentsPageState extends State<ListDocumentsPage> {
  dartz.Either<Failure, List<Document>>? _result;
  final GlobalKey<DocumentsGridState> _gridKey =
      GlobalKey<DocumentsGridState>();
  DocumentsGridMode? _gridMode;

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _result == null
          ? Center(child: CircularProgressIndicator())
          : _result!.fold(
              (failure) => Center(child: Text(failure.message)),
              (documents) =>
                  documents.isNotEmpty ? _documentsGrid(documents) : _empty(),
            ),
      bottomSheet: _isSelectMode() ? _selectModeMenu() : null,
      floatingActionButton: _isSelectMode() ? null : _fab(),
    );
  }

  AppBar _appBar() => AppBar(
        title: _isSelectMode()
            ? _selectOrUnselectAllBox()
            : Text(
                'Documentos',
                style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      );

  Widget _selectOrUnselectAllBox() => Row(
        children: [
          CustomCheckbox(
            value: _gridKey.currentState!.isAllSelected(),
            onChange: (newValue) {
              if (newValue == true) {
                _gridKey.currentState!.selectAll();
              } else {
                _gridKey.currentState!.unselectAll();
              }
            },
          ),
          SizedBox(width: 8),
          Text(
            'Selecionar todos',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
            ),
          ),
        ],
      );

  Widget _documentsGrid(List<Document> documents) => DocumentsGrid(
        key: _gridKey,
        documents: documents,
        onTap: (document) => Modular.to.pushNamed(
          Routes.viewDocument,
          arguments: document,
        ),
        onSelectChange: (_, __) => setState(() {}),
        onModeChange: (newMode) => setState(() {
          _gridMode = newMode;
        }),
      );

  Widget _empty() => Center(
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
      );

  Widget _selectModeMenu() => BottomSheet(
    backgroundColor: Colors.white,
    onClosing: () {},
    builder: (_) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () async {
              final documents = _gridKey.currentState!.getSelected();
              for (final document in documents) {
                final usecase = Modular.get<DeleteDocumentUseCase>();
                final result = await usecase(document);
                print(result);
              }
              _gridKey.currentState!.unselectAll();
              _loadDocuments();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete_outlined),
                SizedBox(height: 4),
                Text('Remover'),
              ],
            ),
          ),
        ],
    ),
  );

  FloatingActionButton? _fab() {
    if (_result == null) {
      return null;
    }
    return _result!.fold(
      (_) => null,
      (documents) => documents.isNotEmpty
          ? FloatingActionButton(
              onPressed: _add,
              child: Icon(Icons.add),
            )
          : null,
    );
  }

  bool _isSelectMode() => _gridMode == DocumentsGridMode.SELECT;

  void _add() {
    Modular.to.pushNamed(Routes.createDocument).then((_) => _loadDocuments());
  }

  void _loadDocuments() {
    final usecase = Modular.get<GetDocumentsUseCase>();
    usecase(NoParams()).then(
      (r) => setState(() {
        _result = r;
      }),
    );
  }
}
