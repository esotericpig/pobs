//---
// Copyright (c) 2022 Jonathan Bradley Whited.
//---

import 'dart:convert' as convert;

import 'package:flutter/foundation.dart' as foundation;
import 'package:http/http.dart' as http;

/// Throws [BadStatusException] if HTTP status code doesn't equal 200.
Future<List<FeedItemModel>> loadFeedItems(int pageNum) async {
  var uri = Uri.parse('${FeedItemModel.endpointUrl}$pageNum');
  var response = await http.get(uri);

  if (response.statusCode != 200) {
    throw BadStatusException(response.statusCode, response.body);
  }

  var body = response.body;
  if (body.isEmpty) return [];

  var json = convert.jsonDecode(body) as List?;
  if (json == null) return [];

  return json.map((j) => FeedItemModel(pageNum, j)).toList();
}

class FeedItemModel {
  // URL w/o page number filled in.
  // - Could change this to use '{}' for lat, lon, & page.
  static const endpointUrl = 'http://161.35.162.216:1210/interview/home/reel?lat=51.5&lon=-0.17&page=';

  // Used in FeedPage to make sure we're not re-loading the same content again.
  final int pageNum;

  // Top ImageBanner.
  late final String authorPhotoUrl;
  late final String authorUsername;
  late final String authorFullName;

  // Photos.
  late final String defaultPhotoUrl;
  late final List<String> photoUrls;

  // Bottom ImageBanner.
  late final String placeLogoUrl;
  late final String placeName;
  late final String placeLocationName;
  late final String placeLocationName0;
  late final String placeLocationFullName;

  // Actions.
  late bool isBookmarked;
  late bool isLiked;

  // Detail bar.
  late final String description;
  late final List<String> tags;
  late final DateTime createdAt;
  late final String createdAtStr;

  /// Throws [BadStatusException] if HTTP status code doesn't equal 200.
  static Future<List<FeedItemModel>> loadFeedItemsInIsolate(int pageNum) async {
    Map<String, dynamic> result = await foundation.compute(
      (int pn) async {
        List<FeedItemModel> feedItems;
        Exception? error;

        try {
          feedItems = await loadFeedItems(pn);
        } on Exception catch (e) {
          feedItems = [];
          error = e;
        }

        return <String, dynamic>{
          'feedItems': feedItems,
          'error': error,
        };
      },
      pageNum,
    );

    Exception? error = result['error'];
    if (error != null) throw error;

    return result['feedItems'];

    // // Tried to do it manually in order to handle errors better,
    // //   but couldn't figure out a better way than a map.
    // // Keeping it here for knowledge base.
    // final rPort = ReceivePort();
    //
    // try {
    //   await Isolate.spawn(
    //     (Map<String, dynamic> data) async {
    //       List<FeedItemModel> feedItems;
    //       Exception? error;
    //
    //       try {
    //         feedItems = await loadFeedItems(data['pageNum']);
    //       } on Exception catch (e) {
    //         feedItems = [];
    //         error = e;
    //       }
    //
    //       Isolate.exit(data['sPort'], <String, dynamic>{
    //         'feedItems': feedItems,
    //         'error': error,
    //       });
    //     },
    //     {
    //       'sPort': rPort.sendPort,
    //       'pageNum': pageNum,
    //     },
    //   );
    //
    //   Map<String, dynamic> result = await rPort.first;
    //   Exception? error = result['error'];
    //
    //   if (error != null) throw error;
    //
    //   return result['feedItems'];
    // } finally {
    //   rPort.close();
    // }
  }

  FeedItemModel(this.pageNum, Map<String, dynamic> json) {
    authorPhotoUrl = json['authorPhotoUrl'] ?? '';
    authorUsername = json['authorUsername'] ?? '';
    authorFullName = json['authorFullName'] ?? '';

    defaultPhotoUrl = json['defaultPhotoUrl'] ?? '';
    photoUrls = buildPhotoUrls(json['photoUrls'], defaultPhotoUrl);

    placeLogoUrl = json['placeLogoUrl'] ?? '';
    placeName = json['placeName'] ?? '';
    placeLocationName = json['placeLocationName'] ?? '';
    placeLocationName0 = json['placeLocationName0'] ?? '';
    placeLocationFullName =
        placeLocationName + (placeLocationName0.isNotEmpty ? ' • $placeLocationName0' : '');

    isBookmarked = json['isBookmarked'] ?? false;
    isLiked = json['isLiked'] ?? false;

    description = json['description'] ?? '';
    tags = buildTags(json['tags_']);
    createdAt = buildDateTime(json['createdAt']);
    createdAtStr = buildCreatedAtStr(createdAt);
  }

  List<String> buildPhotoUrls(List? jsonList, String defaultPhotoUrl) {
    defaultPhotoUrl = defaultPhotoUrl.trim();

    var photoUrls = <String>[];

    if (defaultPhotoUrl.isNotEmpty) photoUrls.add(defaultPhotoUrl);

    if (jsonList == null) return photoUrls;

    for (var j in jsonList) {
      if (j == null) continue;

      var photoUrl = (j as String).trim();

      // Make sure that defaultPhotoUrl is first.
      if (photoUrl.isEmpty || photoUrl == defaultPhotoUrl) continue;

      photoUrls.add(photoUrl);
    }

    return photoUrls;
  }

  List<String> buildTags(List? jsonTags) {
    if (jsonTags == null) return [];
    return jsonTags.map((jsonTag) => jsonTag['name'] as String).toList(growable: false);
  }

  DateTime buildDateTime(String? jsonStr) {
    if (jsonStr != null && jsonStr.isNotEmpty) {
      try {
        return DateTime.parse(jsonStr);
      } on FormatException catch (e, s) {
        // Ignore & return default.
        print('[ERROR] Failed to parse datetime: $e.');
        print('> $s');
      }
    }

    return DateTime.now();
  }

  String buildCreatedAtStr(DateTime createdAt) {
    var diff = DateTime.now().difference(createdAt);

    // This doesn't take into account '1 hour & 59 minutes ago',
    //   but that's okay, no need.
    if (!diff.isNegative) {
      if (diff.inDays > 0) return buildCreatedAtStrPart(diff.inDays, 'day');
      if (diff.inHours > 0) return buildCreatedAtStrPart(diff.inHours, 'hour');
      if (diff.inMinutes > 0) return buildCreatedAtStrPart(diff.inMinutes, 'minute');
      if (diff.inSeconds > 0) return buildCreatedAtStrPart(diff.inSeconds, 'second');
    }

    return 'just now';
  }

  String buildCreatedAtStrPart(int value, String word) {
    return '$value $word${(value == 1) ? '' : 's'} ago';
  }
}

class BadStatusException implements Exception {
  final int code;
  final String body;

  BadStatusException(this.code, this.body);
}
