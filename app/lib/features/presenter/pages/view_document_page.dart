import 'package:doc_warehouse/core/utils/date_formatter.dart';
import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/presenter/widgets/file_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ViewDocumentPage extends StatefulWidget {
  final Document document;

  ViewDocumentPage(this.document);

  @override
  _ViewDocumentPageState createState() => _ViewDocumentPageState();
}

class _ViewDocumentPageState extends State<ViewDocumentPage> {
  @override
  Widget build(BuildContext context) {
    final dateFormatter = Modular.get<DateFormatter>();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        _DocumentPreview(widget.document),
                        Container(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: _DocumentData(widget.document),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Salvo em ${dateFormatter.formatDDMMYYYY(widget.document.creationTime)}',
                      textAlign: TextAlign.end,
                    ),
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () => Modular.to.pop(),
                icon: Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentPreview extends StatelessWidget {

  final Document document;

  const _DocumentPreview(this.document);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      child: FilePreview(
        path: document.filePath,
      ),
      constraints: BoxConstraints(
        minWidth: double.infinity,
        maxHeight: MediaQuery.of(context).size.height * .8,
      ),
    );
  }
}

class _DocumentData extends StatelessWidget {

  final Document document;

  const _DocumentData(this.document);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          document.name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        document.description != null
            ? Text(document.description!)
            : Text(
          'Sem descrição',
          style: TextStyle(color: Colors.grey.shade800),
        ),
      ],
    );
  }
}
