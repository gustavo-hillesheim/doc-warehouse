import 'package:dartz/dartz.dart' as dartz;
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/core/usecase/usecase.dart';
import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/domain/usecases/delete_document_usecase.dart';
import 'package:doc_warehouse/features/domain/usecases/get_documents_usecase.dart';
import 'package:doc_warehouse/features/presenter/widgets/documents_grid.dart';
import 'package:doc_warehouse/features/presenter/widgets/selectable_group/selectable_group.dart';
import 'package:doc_warehouse/features/presenter/widgets/selectable_group/selectable_group_switch.dart';
import 'package:doc_warehouse/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ListDocumentsPage extends StatefulWidget {
  @override
  _ListDocumentsPageState createState() => _ListDocumentsPageState();
}

class _ListDocumentsPageState extends State<ListDocumentsPage> {
  dartz.Either<Failure, List<Document>>? _result;

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return SelectableGroup<Document>(
      builder: (context, isSelectMode) => Scaffold(
        appBar: _appBar(isSelectMode),
        body: _result == null
            ? Center(child: CircularProgressIndicator())
            : _result!.fold(
                (failure) => Center(child: Text(failure.message)),
                (documents) =>
                    documents.isNotEmpty ? _documentsGrid(documents) : _empty(),
              ),
        bottomSheet: isSelectMode ? _selectModeMenu() : null,
        floatingActionButton: isSelectMode ? null : _fab(),
      ),
    );
  }

  AppBar _appBar(bool isSelectMode) => AppBar(
        title: isSelectMode
            ? SelectableGroupSwitch()
            : Text(
                'Documentos',
                style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      );

  Widget _documentsGrid(List<Document> documents) => DocumentsGrid(
        documents: documents,
        onTapDocument: (document) async {
          final shouldReload = await Modular.to.pushNamed(
            Routes.viewDocument,
            arguments: document,
          );
          if (shouldReload == true) {
            _loadDocuments();
          }
        },
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
    builder: (context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () => _deleteSelected(context),
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

  void _deleteSelected(BuildContext context) async {
    final selectableGroup = SelectableGroup.of(context)!;
    final documents = selectableGroup.getAllSelected();
    for (final document in documents) {
    final usecase = Modular.get<DeleteDocumentUseCase>();
    await usecase(document);
    }
    selectableGroup.unselectAll();
    _loadDocuments();
  }

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
