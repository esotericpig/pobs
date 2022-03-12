//---
// Copyright (c) 2022 Jonathan Bradley Whited.
//---

import 'package:flutter/material.dart';
import 'package:spotlas/views/feed_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spotlas'),
      ),
      body: const SafeArea(
        child: FeedPage(),
      ),
    );
  }
}
