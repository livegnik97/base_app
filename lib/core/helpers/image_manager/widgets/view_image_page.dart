import 'dart:io';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum ExtendedImageType { network, asset, file }

class ViewImagePage extends StatelessWidget {
  const ViewImagePage({
    super.key,
    required this.imagePath,
    this.showBtnClose = true,
    this.heroTag,
    this.extendedImageType = ExtendedImageType.network,
  });

  final String imagePath;
  final bool showBtnClose;
  final String? heroTag;
  final ExtendedImageType extendedImageType;

  @override
  Widget build(BuildContext context) {
    Widget extendedImage;
    switch (extendedImageType) {
      case ExtendedImageType.network:
        extendedImage = ExtendedImage(
          image: CachedNetworkImageProvider(imagePath),
          mode: ExtendedImageMode.gesture,
          enableSlideOutPage: true,
        );
        break;
      case ExtendedImageType.asset:
        extendedImage = ExtendedImage.asset(
          imagePath,
          mode: ExtendedImageMode.gesture,
          enableSlideOutPage: true,
        );
        break;
      case ExtendedImageType.file:
        extendedImage = ExtendedImage.file(
          File(imagePath),
          mode: ExtendedImageMode.gesture,
          enableSlideOutPage: true,
        );
        break;
    }

    if (heroTag != null) {
      extendedImage = Hero(tag: heroTag!, child: extendedImage);
    } else {
      extendedImage = FadeInUp(
        duration: const Duration(milliseconds: 300),
        child: extendedImage,
      );
    }

    Widget body = SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: ExtendedImageSlidePage(
        slideAxis: SlideAxis.vertical,
        slideType: SlideType.onlyImage,
        slidePageBackgroundHandler: (offset, size) {
          return defaultSlidePageBackgroundHandler(
            offset: offset,
            pageSize: size,
            color: Colors.black,
            pageGestureAxis: SlideAxis.vertical,
          );
        },
        child: extendedImage,
      ),
    );

    return showBtnClose
        ? Stack(
          children: [
            Positioned.fill(child: body),
            Positioned(
              right: 10,
              top: 15,
              child: IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(Icons.close_outlined, color: Colors.white),
              ),
            ),
          ],
        )
        : body;
  }

  Color defaultSlidePageBackgroundHandler({
    required Offset offset,
    required Size pageSize,
    required Color color,
    required SlideAxis pageGestureAxis,
  }) {
    double opacity = 0.0;
    if (pageGestureAxis == SlideAxis.both) {
      opacity =
          offset.distance /
          (Offset(pageSize.width, pageSize.height).distance / 2.0);
    } else if (pageGestureAxis == SlideAxis.horizontal) {
      opacity = offset.dx.abs() / (pageSize.width / 2.0);
    } else if (pageGestureAxis == SlideAxis.vertical) {
      opacity = offset.dy.abs() / (pageSize.height / 2.0);
    }
    return color.withAlpha((255 * (min(1.0, max(1.0 - opacity, 0.0)))).round());
  }

  // double? defaultSlideScaleHandler({
  //   required Offset offset,
  //   required Size pageSize,
  //   required SlideAxis pageGestureAxis,
  // }) {
  //   double scale = 0.0;
  //   if (pageGestureAxis == SlideAxis.both) {
  //     scale =
  //         offset.distance / Offset(pageSize.width, pageSize.height).distance;
  //   } else if (pageGestureAxis == SlideAxis.horizontal) {
  //     scale = offset.dx.abs() / (pageSize.width / 2.0);
  //   } else if (pageGestureAxis == SlideAxis.vertical) {
  //     scale = offset.dy.abs() / (pageSize.height / 2.0);
  //   }
  //   return max(1.0 - scale, 0.8);
  // }
}
