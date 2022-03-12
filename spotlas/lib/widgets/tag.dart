//---
// Copyright (c) 2022 Jonathan Bradley Whited.
//---

import 'package:flutter/material.dart';

/// One tag (like #tag) as [Chip] at bottom of [FeedItem].
///
/// Looks like a rounded rectangle.
class Tag extends StatelessWidget {
  final String text;

  const Tag({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Chip(
        label: Text(text),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        labelPadding: const EdgeInsets.fromLTRB(4.0, 1.0, 4.0, 2.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        backgroundColor: Colors.white,
        elevation: 3.0,
        shadowColor: Colors.black,
      ),
    );
  }
}
