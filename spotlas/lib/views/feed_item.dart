//---
// Copyright (c) 2022 Jonathan Bradley Whited.
//---

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
import 'package:spotlas/consts.dart' as consts;
import 'package:spotlas/models/feed_item_model.dart';
import 'package:spotlas/widgets/animated_heart.dart';
import 'package:spotlas/widgets/image_banner.dart';
import 'package:spotlas/widgets/more_or_less_text.dart';
import 'package:spotlas/widgets/tag.dart';

class FeedItem extends StatefulWidget {
  final FeedItemModel model;

  const FeedItem({Key? key, required this.model}) : super(key: key);

  @override
  State<FeedItem> createState() => _FeedItemState();
}

class _FeedItemState extends State<FeedItem> {
  bool autoPlayImages = true;
  bool doAnimatedHeart = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SizedBox(
          height: height * 0.60,
          child: Stack(
            children: [
              buildImages(),
              buildImageBannersAndHeart(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
          child: Column(
            children: [
              buildActions(),
              // Description.
              Align(
                alignment: Alignment.topLeft,
                child: MoreOrLessText(
                  name: widget.model.authorUsername,
                  text: widget.model.description,
                ),
              ),
              // Tags.
              Padding(
                padding: const EdgeInsets.only(top: 3.0, bottom: 5.0),
                // Can't use ListView because need height for that.
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: widget.model.tags.map((tagText) {
                      return Tag(text: tagText);
                    }).toList(growable: false),
                  ),
                ),
              ),
              // Created-at ('X days ago') text.
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.model.createdAtStr,
                  style: TextStyle(
                    color: consts.darkGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildImages() {
    return Positioned.fill(
      child: GestureDetector(
        onDoubleTap: () {
          setState(() {
            widget.model.isLiked = !widget.model.isLiked;
            if (widget.model.isLiked) doAnimatedHeart = true;
          });
        },
        child: Listener(
          onPointerDown: (event) => setState(() => autoPlayImages = false),
          child: Swiper(
            pagination: const SwiperPagination(),
            control: const SwiperControl(),
            loop: false,
            autoplay: autoPlayImages,
            autoplayDelay: 5000,
            // Doesn't work with DEFAULT layout, so use autoPlayImages instance var.
            autoplayDisableOnInteraction: true,
            itemCount: widget.model.photoUrls.length,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                fit: BoxFit.cover,
                alignment: Alignment.center,
                imageUrl: widget.model.photoUrls[index],
                placeholder: consts.cacheNetImgPlaceHolderBuilder,
                errorWidget: consts.cacheNetImgErrorWidgetBuilder,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildImageBannersAndHeart() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: ImageBanner(
              leftImageUrl: widget.model.authorPhotoUrl,
              topText: widget.model.authorUsername,
              bottomText: widget.model.authorFullName,
              rightAction: TextButton(
                onPressed: () {},
                child: SvgPicture.asset(
                  'assets/images/Options.svg',
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Center(
              child: AnimatedHeart(
                doAnimate: doAnimatedHeart,
                onEnd: () => setState(() => doAnimatedHeart = false),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ImageBanner(
              leftImageUrl: widget.model.placeLogoUrl,
              topText: widget.model.placeName,
              bottomText: widget.model.placeLocationFullName,
              rightAction: LikeButton(
                isLiked: widget.model.isBookmarked,
                likeBuilder: (saved) {
                  widget.model.isBookmarked = saved;
                  return SvgPicture.asset(
                    'assets/images/' + (saved ? 'Star.svg' : 'Star Border.svg'),
                    color: saved ? consts.starColor : Colors.white,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 1.0),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {},
              child: SvgPicture.asset('assets/images/Map.svg'),
            ),
          ),
          Expanded(
            child: TextButton(
              onPressed: () {},
              child: SvgPicture.asset('assets/images/Comment.svg'),
            ),
          ),
          // Wrap in TextButton to get same spacing/padding & to have click-hand cursor.
          Expanded(
            child: TextButton(
              onPressed: () {},
              child: LikeButton(
                isLiked: widget.model.isLiked,
                likeBuilder: (liked) {
                  widget.model.isLiked = liked;
                  return SvgPicture.asset(
                    'assets/images/' + (liked ? 'Heart.svg' : 'Like.svg'),
                    color: (liked ? consts.heartColor : null),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: TextButton(
              onPressed: () {},
              child: SvgPicture.asset('assets/images/Share.svg'),
            ),
          ),
        ],
      ),
    );
  }
}
