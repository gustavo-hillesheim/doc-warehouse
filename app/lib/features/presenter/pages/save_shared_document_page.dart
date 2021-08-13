import 'package:doc_warehouse/core/utils/share_intent_receiver.dart';
import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/domain/usecases/create_document_usecase.dart';
import 'package:doc_warehouse/features/presenter/widgets/document_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SaveSharedDocumentPage extends StatefulWidget {
  final SharedFile sharedFile;

  SaveSharedDocumentPage(this.sharedFile);

  @override
  _SaveSharedDocumentPageState createState() => _SaveSharedDocumentPageState();
}

class _SaveSharedDocumentPageState extends State<SaveSharedDocumentPage> {
  late Document _formInitialValue;

  @override
  void initState() {
    print('in save shared document page');
    super.initState();
    _formInitialValue = Document(
      filePath: widget.sharedFile.path,
      name: widget.sharedFile.name.substring(0, widget.sharedFile.name.lastIndexOf('.')),
      creationTime: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DocumentForm(
          initialValue: _formInitialValue,
          onCancel: Modular.to.pop,
          onSave: (doc) => _save(doc, context),
        ),
      ),
    );
  }

  void _save(Document document, BuildContext context) async {
    final result = await Modular.get<CreateDocumentUseCase>()(document);
    result.fold(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Não foi possível criar o documento: ${failure.message}'))),
      (_) => Modular.to.pop(true),
    );
  }
}
