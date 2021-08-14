import 'package:badges/badges.dart';
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/core/utils/share_intent_receiver.dart';
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
  final _shareIntentReceiver = ShareIntentReceiver();
  String? filter;

  @override
  void initState() {
    super.initState();
    _shareIntentReceiver.fileStream.listen((sharedFile) async {
      Modular.to
          .pushNamed(Routes.saveSharedDocument, arguments: sharedFile)
          .then((shouldReload) {
        if (shouldReload == true) {
          store.loadDocuments();
        }
      });
    });
    store.loadDocuments();
  }

  @override
  void dispose() {
    _shareIntentReceiver.close();
    super.dispose();
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
        actions: isSelectMode
            ? []
            : [
                IconButton(
                    icon: Badge(
                      badgeContent: Text('1'),
                      showBadge: filter != null && filter!.isNotEmpty,
                      badgeColor: Colors.red,
                      child: Icon(
                        Icons.filter_list_outlined,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                    onPressed: _openFilter,
                    splashRadius: 24),
              ],
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      );

  void _openFilter() {
    var overlayEntry;
    final textController = TextEditingController(text: filter);
    final textFieldfocusNode = FocusNode()..requestFocus();
    overlayEntry = OverlayEntry(
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => overlayEntry.remove(),
                  ),
                ),
                PhysicalModel(
                  color: Theme.of(context).backgroundColor,
                  elevation: 16,
                  shadowColor: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: textController,
                            focusNode: textFieldfocusNode,
                            onChanged: _updateFilter,
                            onEditingComplete: overlayEntry.remove,
                            onSaved: (_) => overlayEntry.remove(),
                            onFieldSubmitted: (_) => overlayEntry.remove(),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search_outlined),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            textController.text = '';
                            _updateFilter('');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom,
                ),
              ],
            ),
          );
        },
        opaque: false);
    Overlay.of(context)?.insert(overlayEntry);
  }

  void _updateFilter(String newFilter) {
    setState(() {
      filter = newFilter;
    });
    store.loadDocuments(newFilter);
  }

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
    final selectableGroup =
        SelectableGroup.of<Document>(selectableGroupContext)!;
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
