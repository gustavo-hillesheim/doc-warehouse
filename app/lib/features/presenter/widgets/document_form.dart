import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/presenter/widgets/file_selector.dart';
import 'package:doc_warehouse/features/presenter/widgets/page_view_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DocumentForm extends StatefulWidget {
  final Document? initialValue;
  final ValueChanged<Document> onSave;
  final VoidCallback onCancel;

  const DocumentForm({
    Key? key,
    required this.onSave,
    required this.onCancel,
    this.initialValue,
  }) : super(key: key);

  @override
  _DocumentFormState createState() => _DocumentFormState();
}

class _DocumentFormState extends State<DocumentForm> {
  FileReference? _selectedFile;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _nameController.text = widget.initialValue!.name;
      _descriptionController.text = widget.initialValue!.description ?? '';
      _selectedFile = FileReference(
        name: widget.initialValue!.name,
        path: widget.initialValue!.filePath,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(color: Theme.of(context).primaryColor),
      child: PageViewForm(
        pages: [
          _fileSelectorPage(),
          _nameInputPage(),
          _buildDescriptionInput(),
        ],
        onCancel: widget.onCancel,
        onSave: _onSave,
      ),
    );
  }

  void _onSave() {
    final description = _descriptionController.text.isNotEmpty
        ? _descriptionController.text
        : null;
    final document = Document(
      id: widget.initialValue?.id,
      name: _nameController.text,
      filePath: _selectedFile!.path,
      description: description,
      creationTime: widget.initialValue?.creationTime ?? DateTime.now(),
    );
    widget.onSave(document);
  }

  PageInput _fileSelectorPage() {
    return PageInput(
      titleBuilder: (_) => Text('Escolha um arquivo'),
      inputBuilder: (_, onChanged) => Center(
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
                    if (_nameController.text.isEmpty) {
                      _nameController.text = file.name.substring(0, file.name.lastIndexOf('.'));
                    }
                    onChanged();
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

  PageInput _nameInputPage() {
    return PageInput(
      titleBuilder: (_) => Text('Qual o nome do arquivo?'),
      inputBuilder: (_, onChanged) => TextField(
        controller: _nameController,
        onChanged: (_) => onChanged(),
        showCursor: false,
        decoration: InputDecoration(labelText: 'Nome'),
      ),
      validator: () => _nameController.text.isNotEmpty,
    );
  }

  PageInput _buildDescriptionInput() {
    return PageInput(
      titleBuilder: (_) => Text('O que é esse arquivo?'),
      inputBuilder: (_, onChanged) => TextField(
        controller: _descriptionController,
        onChanged: (_) => onChanged(),
        decoration: InputDecoration(labelText: 'Descrição (Opcional)'),
        maxLines: null,
        keyboardType: TextInputType.multiline,
      ),
    );
  }
}
