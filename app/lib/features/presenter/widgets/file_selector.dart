import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FileSelector extends StatefulWidget {
  final ValueChanged<File> onSelect;
  final File? initialValue;

  FileSelector({required this.onSelect, this.initialValue});

  @override
  _FileSelectorState createState() => _FileSelectorState();
}

class _FileSelectorState extends State<FileSelector> {
  File? _selectedFile;

  @override
  void initState() {
    super.initState();
    _selectedFile = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).primaryColor;
    return Container(
      decoration: ShapeDecoration(
        color: backgroundColor.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          side: BorderSide(
            style: BorderStyle.solid,
            color: backgroundColor,
          ),
        ),
      ),
      child: InkWell(
        onTap: _selectFile,
        child: _selectedFile == null ? _noFileText() : _filePreview(),
      ),
    );
  }

  Widget _noFileText() => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Center(
      child: Text(
        'Procurar Arquivo',
        softWrap: true,
        style: TextStyle(fontSize: 24),
        textAlign: TextAlign.center,
      ),
    ),
  );

  Widget _filePreview() => Center(
    child: Icon(Icons.file_copy_outlined, size: 64),
  );

  void _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      _setSelectedFile(result.files.single);
    }
  }

  void _setSelectedFile(PlatformFile platformFile) {
    final file = File.fromPlatformFile(platformFile);
    _selectedFile = file;
    widget.onSelect(file);
  }
}

class File {
  final String name;
  final String? path;

  const File({required this.name, required this.path});

  factory File.fromPlatformFile(PlatformFile platformFile) {
    return File(
      name: platformFile.name,
      path: platformFile.path,
    );
  }
}
