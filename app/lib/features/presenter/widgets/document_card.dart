import 'package:auto_size_text/auto_size_text.dart';
import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/presenter/widgets/file_preview.dart';
import 'package:doc_warehouse/features/presenter/widgets/square.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

const titleStyle = TextStyle(fontSize: 14);

class DocumentCard extends StatelessWidget {
  final Document document;

  DocumentCard(this.document);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Stack(children: [
        Square(
          child: FilePreview(path: document.filePath),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.all(4),
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 18,
                    child: AutoSizeText(
                      document.name,
                      minFontSize: titleStyle.fontSize,
                      maxFontSize: titleStyle.fontSize,
                      maxLines: 1,
                      softWrap: false,
                      style: titleStyle,
                      overflowReplacement: Marquee(
                        text: document.name,
                        style: titleStyle,
                        blankSpace: 25,
                        fadingEdgeEndFraction: 0.2,
                        fadingEdgeStartFraction: 0.05,
                        showFadingOnlyWhenScrolling: false,
                        startAfter: Duration(seconds: 1),
                        pauseAfterRound: Duration(seconds: 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
