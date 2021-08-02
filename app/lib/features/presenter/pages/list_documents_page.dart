import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/domain/usecases/create_document_usecase.dart';
import 'package:doc_warehouse/features/domain/usecases/delete_documents_usecase.dart';
import 'package:doc_warehouse/features/presenter/controller/list_documents_store.dart';
import 'package:doc_warehouse/features/presenter/widgets/documents_grid.dart';
import 'package:doc_warehouse/features/presenter/widgets/selectable_group/selectable_group.dart';
import 'package:doc_warehouse/features/presenter/widgets/selectable_group/selectable_group_switch.dart';
import 'package:doc_warehouse/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class ListDocumentsPage extends StatefulWidget {
  @override
  _ListDocumentsPageState createState() => _ListDocumentsPageState();
}

class _ListDocumentsPageState
    extends ModularState<ListDocumentsPage, ListDocumentsStore> {
  @override
  void initState() {
    super.initState();
    store.loadDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return SelectableGroup<Document>(
      builder: (context, isSelectMode) => Scaffold(
        appBar: _appBar(isSelectMode),
        body: ScopedBuilder<ListDocumentsStore, Failure, List<Document>>(
          store: store,
          onError: (_, failure) => Center(child: Text(failure!.message)),
          onLoading: (_) => Center(child: CircularProgressIndicator()),
          onState: (_, documents) =>
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
            store.loadDocuments();
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

  Widget _fab() {
    return ScopedBuilder<ListDocumentsStore, Failure, List<Document>>(
      store: store,
      onState: (_, documents) => documents.isNotEmpty
          ? FloatingActionButton(
              onPressed: _add,
              child: Icon(Icons.add),
            )
          : Container(),
    );
  }

  void _deleteSelected(BuildContext selectableGroupContext) async {
    final selectableGroup = SelectableGroup.of<Document>(selectableGroupContext)!;
    final documents = selectableGroup.getAllSelected();
    final usecase = Modular.get<DeleteDocumentsUseCase>();
    final result = await usecase(documents);
    result.fold(
      (failure) => _showSnackBar(
          context, 'Não foi possível remover os documents: ${failure.message}'),
      (_) => _showSnackBar(
        context,
        'Documentos removidos!',
        SnackBarAction(
          textColor: Colors.blue,
          label: 'Desfazer',
          onPressed: () async {
            final createUsecase = Modular.get<CreateDocumentUseCase>();
            for (final document in documents) {
              final result = await createUsecase(document);
              result.fold(
                  (failure) => _showSnackBar(context,
                      'Não foi possível recuperar o documento \"${document.name}\": ${failure.message}'),
                  (_) {});
            }
            store.loadDocuments();
          },
        ),
      ),
    );
    selectableGroup.unselectAll();
    store.loadDocuments();
  }

  void _showSnackBar(BuildContext context, String message,
      [SnackBarAction? action]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: action,
      ),
    );
  }

  void _add() {
    Modular.to
        .pushNamed(Routes.createDocument)
        .then((_) => store.loadDocuments());
  }
}
