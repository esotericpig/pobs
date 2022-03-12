//---
// Copyright (c) 2022 Jonathan Bradley Whited.
//---

import 'package:flutter/material.dart';
import 'package:spotlas/consts.dart' as consts;
import 'package:spotlas/views/home_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotlas',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          color: consts.mainColor,
        ),
      ),
      home: const HomePage(),
    );
  }
}
