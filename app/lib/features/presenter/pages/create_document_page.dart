import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/domain/usecases/create_document_usecase.dart';
import 'package:doc_warehouse/features/presenter/widgets/document_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CreateDocumentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DocumentForm(
          onCancel: Modular.to.pop,
          onSave: _save,
        ),
      ),
    );
  }

  void _save(Document document) async {
    final result = await Modular.get<CreateDocumentUseCase>()(document);
    result.fold(
      (failure) => print('Failure $failure'),
      (_) => Modular.to.pop(),
    );
  }
}
