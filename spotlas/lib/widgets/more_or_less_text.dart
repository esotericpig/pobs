//---
// Copyright (c) 2022 Jonathan Bradley Whited.
//---

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:spotlas/consts.dart' as consts;

/// Long text with expandable `more...` or `less` at end if too long.
///
/// Example layout:
/// ```
/// (name)  (long text)  (more|less)
/// ```
class MoreOrLessText extends StatefulWidget {
  final String name;
  final String text;

  const MoreOrLessText({
    Key? key,
    required this.name,
    required this.text,
  }) : super(key: key);

  @override
  State<MoreOrLessText> createState() => _MoreOrLessTextState();
}

class _MoreOrLessTextState extends State<MoreOrLessText> {
  static const maxLines = 3;

  bool isTrimmed = true;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        var textSpan = TextSpan(
          children: [
            TextSpan(
              text: widget.name + '  ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: widget.text),
          ],
        );

        var textPainter = TextPainter(
          text: textSpan,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          maxLines: maxLines,
        )..layout(
            minWidth: constraints.minWidth,
            maxWidth: constraints.maxWidth,
          );

        // Keeping this for the future in case need it to make this work better.
        // var rp = RenderParagraph(
        //   textSpan,
        //   textAlign: TextAlign.left,
        //   textDirection: TextDirection.ltr,
        //   textScaleFactor: MediaQuery.of(context).textScaleFactor,
        //   maxLines: maxLines,
        // )..layout(constraints);

        return buildWidget(textSpan, textPainter.didExceedMaxLines);
      },
    );
  }

  Widget buildWidget(TextSpan textSpan, bool doTrim) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: Column(
        children: [
          Text.rich(
            textSpan,
            overflow: TextOverflow.clip,
            maxLines: (doTrim && isTrimmed) ? maxLines : null,
          ),
          if (doTrim)
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: InkWell(
                  onTap: () => setState(() => isTrimmed = !isTrimmed),
                  child: Text(
                    isTrimmed ? 'more...' : 'less     ',
                    style: TextStyle(
                      color: consts.darkGrey,
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
