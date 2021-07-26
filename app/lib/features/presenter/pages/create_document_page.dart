import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/domain/usecases/create_document_usecase.dart';
import 'package:doc_warehouse/features/presenter/widgets/file_selector.dart';
import 'package:doc_warehouse/features/presenter/widgets/page_view_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CreateDocumentPage extends StatefulWidget {
  @override
  _CreateDocumentPageState createState() => _CreateDocumentPageState();
}

class _CreateDocumentPageState extends State<CreateDocumentPage> {
  FileReference? _selectedFile;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  static final _kInputBorder = UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.black.withOpacity(0.2),
      width: 2,
    ),
  );
  static final _kInputDecoration = InputDecoration(
    alignLabelWithHint: true,
    focusedBorder: _kInputBorder.copyWith(
      borderSide: _kInputBorder.borderSide.copyWith(
        color: Colors.black.withOpacity(0.4),
      ),
    ),
    border: _kInputBorder,
    focusColor: Colors.black.withOpacity(0.2),
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTextStyle(
      style: TextStyle(color: Theme.of(context).primaryColor),
      child: SafeArea(
          child: PageViewForm(
            pages: [
                  (_, onChange) => _buildFileSelector(onChange),
                  (_, onChange) => _buildNameInput(onChange),
                  (_, onChange) => _buildDescriptionInput(onChange),
            ],
            onCancel: Modular.to.pop,
            onSave: _save,
          ),
        ),
      ),
    );
  }

  void _save() async {
    final description = _descriptionController.text.isNotEmpty
        ? _descriptionController.text
        : null;
    final document = Document(
      name: _nameController.text,
      filePath: _selectedFile!.path,
      description: description,
      creationTime: DateTime.now(),
    );
    final result = await Modular.get<CreateDocumentUseCase>()(document);
    result.fold(
      (failure) => print('Failure $failure'),
      (_) => Modular.to.pop(),
    );
  }

  PageInput _buildFileSelector(VoidCallback onChange) {
    return PageInput(
      title: Text('Escolha um arquivo'),
      input: Center(
          child: Column(
        children: [
          FractionallySizedBox(
            child: LayoutBuilder(
              builder: (_, bounds) => Container(
                height: bounds.maxWidth,
                width: bounds.maxWidth,
                child: FileSelector(
                  initialValue: _selectedFile,
                  onSelect: (file) {
                    _selectedFile = file;
                    _nameController.text = file.name;
                    onChange();
                  },
                ),
              ),
            ),
            widthFactor: 0.5,
          ),
        ],
      )),
      validator: () => _selectedFile != null,
    );
  }

  PageInput _buildNameInput(VoidCallback onChange) {
    return PageInput(
      title: Text('Qual o nome do arquivo?'),
      input: TextField(
        controller: _nameController,
        onChanged: (_) => onChange(),
        showCursor: false,
        decoration: _kInputDecoration.copyWith(labelText: 'Nome'),
      ),
      validator: () => _nameController.text.isNotEmpty,
    );
  }

  PageInput _buildDescriptionInput(VoidCallback onChange) {
    return PageInput(
      title: Text('O que é esse arquivo?'),
      input: TextField(
        controller: _descriptionController,
        onChanged: (_) => onChange(),
        decoration:
            _kInputDecoration.copyWith(labelText: 'Descrição (Opcional)'),
      ),
    );
  }
}
