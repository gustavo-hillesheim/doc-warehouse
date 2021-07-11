import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/presenter/widgets/custom_checkbox.dart';
import 'package:doc_warehouse/features/presenter/widgets/document_card.dart';
import 'package:flutter/material.dart';

enum DocumentsGridMode { VIEW, SELECT, AUTO }

typedef OnSelectChange = void Function(Document document, bool isSelected);

class DocumentsGrid extends StatefulWidget {
  final List<Document> documents;
  final DocumentsGridMode mode;
  final ValueChanged<Document>? onTap;
  final OnSelectChange? onSelectChange;
  final ValueChanged<DocumentsGridMode>? onModeChange;

  DocumentsGrid({
    Key? key,
    required this.documents,
    this.mode = DocumentsGridMode.AUTO,
    this.onTap,
    this.onSelectChange,
    this.onModeChange,
  }) : super(key: key);

  @override
  DocumentsGridState createState() => DocumentsGridState();
}

class DocumentsGridState extends State<DocumentsGrid> {
  final Set<Document> _selectedDocuments = {};
  late DocumentsGridMode _mode;

  @override
  void initState() {
    super.initState();
    _mode = widget.mode;
  }

  @override
  void didUpdateWidget(DocumentsGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mode != oldWidget.mode) {
      _mode = widget.mode;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _maxCardWidth = 120;
    return GridView.builder(
      padding: EdgeInsets.all(4),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width ~/ _maxCardWidth,
        childAspectRatio: 1,
      ),
      itemBuilder: (_, index) {
        final document = widget.documents.elementAt(index);
        return Padding(
          padding: const EdgeInsets.all(4),
          child: _GridItem(
            document: document,
            isSelectable: _mode == DocumentsGridMode.SELECT,
            isSelected: _selectedDocuments.contains(document),
            onTap: () => _onTap(document),
            onLongPress: () => _onSelect(document),
          ),
        );
      },
      itemCount: widget.documents.length,
    );
  }

  bool isAllSelected() {
    return _selectedDocuments.containsAll(widget.documents);
  }

  void selectAll() {
    setState(() {
      widget.documents.forEach((document) {
        if (!_selectedDocuments.contains(document)) {
          _select(document);
        }
      });
    });
  }

  void unselectAll() {
    setState(() {
      widget.documents.forEach((document) {
        if (_selectedDocuments.contains(document)) {
          _unselect(document);
        }
      });
    });
  }

  List<Document> getSelected() {
    return _selectedDocuments.toList(growable: false);
  }

  void _onTap(Document document) {
    if (_mode == DocumentsGridMode.SELECT) {
      _updateSelected(document);
    } else if (widget.onTap != null) {
      widget.onTap!(document);
    }
  }

  void _onSelect(Document document) {
    if (_mode == DocumentsGridMode.AUTO) {
      setState(() {
        _setMode(DocumentsGridMode.SELECT);
      });
    }
    if (_mode == DocumentsGridMode.SELECT) {
      _updateSelected(document);
    }
  }

  void _updateSelected(Document document) {
    setState(() {
      if (!_selectedDocuments.contains(document)) {
        _select(document);
      } else {
        _unselect(document);
      }
    });
  }

  void _setMode(DocumentsGridMode newMode) {
    if (newMode != _mode) {
      _mode = newMode;
      if (widget.onModeChange != null) {
        widget.onModeChange!(_mode);
      }
    }
  }

  _select(Document document) {
    _selectedDocuments.add(document);
    if (widget.onSelectChange != null) {
      widget.onSelectChange!(document, true);
    }
  }

  _unselect(Document document) {
    _selectedDocuments.remove(document);
    if (widget.onSelectChange != null) {
      widget.onSelectChange!(document, false);
    }
    if (_selectedDocuments.isEmpty) {
      _setMode(widget.mode);
    }
  }
}

class _GridItem extends StatelessWidget {
  final Document document;
  final bool isSelectable;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  _GridItem({
    required this.document,
    this.isSelectable = false,
    this.isSelected = false,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DocumentCard(document),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
          ),
        ),
        isSelectable
            ? Container(
                margin: const EdgeInsets.all(8),
                child: CustomCheckbox(
                  value: isSelected,
                  onChange: (_) {},
                ),
              )
            : Container(),
      ],
    );
  }
}
