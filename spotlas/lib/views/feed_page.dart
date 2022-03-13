//---
// Copyright (c) 2022 Jonathan Bradley Whited.
//---

import 'package:flutter/material.dart';
import 'package:spotlas/models/feed_item_model.dart';
import 'package:spotlas/views/feed_item.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  var nextPageNum = 1;
  final models = <FeedItemModel>[];

  @override
  void initState() {
    super.initState();
    loadNextPage();
  }

  Future<void> loadNextPage() async {
    // No more pages left.
    if (nextPageNum <= 0) return;

    // Unlikely to ever happen, but just in case call this method twice
    //   before it has finished updating nextPageNum.
    if (models.isNotEmpty && models.last.pageNum >= nextPageNum) return;

    try {
      var nextModels = await FeedItemModel.loadFeedItemsInIsolate(nextPageNum);

      if (nextModels.isEmpty) {
        nextPageNum = 0; // No more pages, so stop hitting server.
        return;
      }

      ++nextPageNum;
      setState(() => models.addAll(nextModels));
    } on BadStatusException catch (e) {
      print('[ERROR] Failed to load feed items...');
      print('> Status code:   ${e.code}');
      print('> Response body: ${e.body}');
    } on Exception catch (e) {
      print('[ERROR] Failed to load feed items: $e.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: models.length,
      itemBuilder: (context, index) {
        // Just for testing paging.
        print('[Page #${nextPageNum - 1}]: FeedItem #${index + 1} of ${models.length}.');

        // When 2 before last, try to load next page items.
        if (index >= (models.length - 2)) loadNextPage();

        return FeedItem(model: models[index]);
      },
    );
  }
}
