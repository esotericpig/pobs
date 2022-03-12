//---
// Copyright (c) 2022 Jonathan Bradley Whited.
//---

// ignore_for_file: prefer_function_declarations_over_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

const mainColor = Color.fromARGB(255, 255, 0, 93);

const heartColor = Color.fromARGB(255, 255, 0, 105);
const starColor = Color.fromARGB(255, 255, 198, 0);
final lightGrey = Colors.grey.shade300;
final darkGrey = Colors.grey.shade400;

final PlaceholderWidgetBuilder cacheNetImgPlaceHolderBuilder = (context, url) {
  return const CircularProgressIndicator();
};

final LoadingErrorWidgetBuilder cacheNetImgErrorWidgetBuilder = (context, url, error) {
  return const FittedBox(child: Icon(Icons.error_outline));
};
