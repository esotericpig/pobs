//---
// Copyright (c) 2022 Jonathan Bradley Whited.
//---

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spotlas/consts.dart' as consts;

/// Banner at top & bottom of image.
///
/// Example layout:
/// ```
///       text
/// (img) -------- (action)
///       text
/// ```
class ImageBanner extends StatelessWidget {
  final Color leftImageBorderColor;
  final String leftImageUrl;
  final String topText;
  final String bottomText;
  final Widget rightAction;

  const ImageBanner({
    Key? key,
    required this.leftImageBorderColor,
    required this.leftImageUrl,
    required this.topText,
    required this.bottomText,
    required this.rightAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: FittedBox(
              fit: BoxFit.cover,
              child: CircleAvatar(
                backgroundColor: leftImageBorderColor,
                child: Padding(
                  padding: const EdgeInsets.all(2.5),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: leftImageUrl,
                      placeholder: consts.cacheNetImgPlaceHolderBuilder,
                      errorWidget: consts.cacheNetImgErrorWidgetBuilder,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: Text(
                      topText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    bottomText,
                    style: TextStyle(
                      color: consts.lightGrey,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: rightAction,
        ),
      ],
    );
  }
}
