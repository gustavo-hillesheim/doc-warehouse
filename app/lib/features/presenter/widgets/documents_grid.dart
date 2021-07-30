import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/presenter/widgets/document_card.dart';
import 'package:doc_warehouse/features/presenter/widgets/selectable_group/selectable_item.dart';
import 'package:flutter/material.dart';

class DocumentsGrid extends StatelessWidget {
  final List<Document> documents;
  final ValueChanged<Document>? onTapDocument;

  DocumentsGrid({
    Key? key,
    required this.documents,
    this.onTapDocument,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _maxCardWidth = 120;
    return GridView.builder(
      padding: EdgeInsets.all(4),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width ~/ _maxCardWidth,
        childAspectRatio: 1,
      ),
      itemBuilder: _itemBuilder,
      itemCount: documents.length,
    );
  }

  Widget _itemBuilder(_, index) {
    final document = documents.elementAt(index);
    return Padding(
      padding: const EdgeInsets.all(4),
      child: SelectableItem<Document>(
        value: document,
        child: Stack(
          children: [
            DocumentCard(document),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _onTap(document),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(Document document) {
    if (onTapDocument != null) {
      onTapDocument!(document);
    }
  }
}
