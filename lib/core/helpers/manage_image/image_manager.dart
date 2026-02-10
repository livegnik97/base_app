import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/imagen_path.dart';
import 'widgets/view_gallery_image_page.dart';
import 'widgets/view_image_page.dart';

typedef OnProgress = void Function(double progress);

class ImageManager {
  //* show gallery image
  static void showGalleryImage({
    required BuildContext context,
    int initialPage = 0,
    required List<ImageItem> imagesItem,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, _) => ViewGalleryImagePage(
          initialPage: initialPage,
          imagesItem: imagesItem,
        ),
      ),
    );
  }

  //* show image
  static void showImage({
    required BuildContext context,
    required String imagePath,
    String? heroTag,
    required ExtendedImageType extendedImageType,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, _) => ViewImagePage(
          imagePath: imagePath,
          heroTag: heroTag,
          extendedImageType: extendedImageType,
        ),
      ),
    );
  }

  static void showImageFromNetwork({
    required BuildContext context,
    required String imagePath,
    String? heroTag,
  }) {
    showImage(
      context: context,
      imagePath: imagePath,
      heroTag: heroTag,
      extendedImageType: ExtendedImageType.network,
    );
  }

  static void showImageFromAsset({
    required BuildContext context,
    required String imagePath,
    String? heroTag,
  }) {
    showImage(
      context: context,
      imagePath: imagePath,
      heroTag: heroTag,
      extendedImageType: ExtendedImageType.asset,
    );
  }

  static void showImageFromFile({
    required BuildContext context,
    required String imagePath,
    String? heroTag,
  }) {
    showImage(
      context: context,
      imagePath: imagePath,
      heroTag: heroTag,
      extendedImageType: ExtendedImageType.file,
    );
  }

  //* get image from gallery
  static Future<String?> getImagePathFromGallery({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async {
    XFile? image = await getImageFromGallery(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      preferredCameraDevice: preferredCameraDevice,
      requestFullMetadata: requestFullMetadata,
    );
    if (image != null) {
      String? imagePath = image.path;
      return imagePath;
    }
    return null;
  }

  static Future<XFile?> getImageFromGallery({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async {
    return _getImage(
      ImageSource.gallery,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      preferredCameraDevice: preferredCameraDevice,
      requestFullMetadata: requestFullMetadata,
    );
  }

  //* get image from camera
  static Future<String?> getImagePathFromCamera({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async {
    XFile? image = await getImageFromCamera(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      preferredCameraDevice: preferredCameraDevice,
      requestFullMetadata: requestFullMetadata,
    );
    if (image != null) {
      String? imagePath = image.path;
      return imagePath;
    }
    return null;
  }

  static Future<XFile?> getImageFromCamera({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async {
    return _getImage(
      ImageSource.camera,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      preferredCameraDevice: preferredCameraDevice,
      requestFullMetadata: requestFullMetadata,
    );
  }

  //* get image private
  static Future<XFile?> _getImage(
    ImageSource source, {
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async {
    try {
      return await ImagePicker().pickImage(
        source: source,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
        preferredCameraDevice: preferredCameraDevice,
        requestFullMetadata: requestFullMetadata,
      );
    } catch (_) {}
    return null;
  }

  //* get image list from gallery
  static Future<List<String>> getImagePathFromGalleryList({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    int? limit,
    bool requestFullMetadata = true,
  }) async {
    return (await getImageFromGalleryList()).map((e) => e.path).toList();
  }

  static Future<List<XFile>> getImageFromGalleryList({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    int? limit,
    bool requestFullMetadata = true,
  }) async {
    try {
      return await ImagePicker().pickMultiImage(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
        limit: limit,
        requestFullMetadata: requestFullMetadata,
      );
    } catch (_) {}
    return [];
  }

  //* image file widget
  static Widget imageAssetWidget(
    String path, {
    Color? color,
    String placeholderPath = ImagenPath.placeholder,
    Widget? placeholderWidget,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    bool withLoading = true,
    OnProgress? onProgress,
  }) {
    final placeholderImage =
        placeholderWidget ??
        Image(
          image: AssetImage(placeholderPath),
          width: width,
          height: height,
          fit: fit,
        );
    if (path.isEmpty) return placeholderImage;

    return Image.asset(
      path,
      color: color,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return placeholderImage;
      },
    );
  }

  //* image file widget
  static Widget imageFileWidget(
    String path, {
    String placeholderPath = ImagenPath.placeholder,
    Widget? placeholderWidget,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    bool withLoading = true,
    OnProgress? onProgress,
  }) {
    final placeholderImage =
        placeholderWidget ??
        Image(
          image: AssetImage(placeholderPath),
          width: width,
          height: height,
          fit: fit,
        );
    if (path.isEmpty) return placeholderImage;

    return Image.file(
      File(path),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return placeholderImage;
      },
    );
  }

  //* image network widget
  static Widget imageNetworkWidget(
    String path, {
    String placeholderPath = ImagenPath.placeholder,
    Widget? placeholderWidget,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    bool withLoading = true,
    OnProgress? onProgress,
  }) {
    final placeholderImage =
        placeholderWidget ??
        Image(
          image: AssetImage(placeholderPath),
          width: width,
          height: height,
          fit: fit,
        );
    if (path.isEmpty) return placeholderImage;

    return Image.network(
      path,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress != null) {
          double progress = (loadingProgress.expectedTotalBytes != null)
              ? (loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!)
                    .toDouble()
              : -1;
          if (onProgress != null) onProgress(progress);
          return !withLoading
              ? placeholderImage
              : Container(
                  width: width,
                  height: height,
                  color: Colors.black12,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: progress != -1 ? progress : null,
                    ),
                  ),
                );
        }
        return FadeIn(child: child);
      },
      errorBuilder: (context, error, stackTrace) {
        return placeholderImage;
      },
    );
  }

  //* cache image network widget
  static Widget cacheImageNetworkWidget(
    String path, {
    String placeholderPath = ImagenPath.placeholder,
    Widget? placeholderWidget,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    bool withLoading = true,
    OnProgress? onProgress,
  }) {
    final placeholderImage =
        placeholderWidget ??
        Image(
          image: AssetImage(placeholderPath),
          width: width,
          height: height,
          fit: fit,
        );
    if (path.isEmpty) return placeholderImage;

    return CachedNetworkImage(
      imageUrl: path,
      width: width,
      height: height,
      fit: fit,
      progressIndicatorBuilder: (context, url, downloadProgress) {
        double progress = downloadProgress.progress != null
            ? downloadProgress.progress!
            : -1;
        if (onProgress != null) onProgress(progress);
        return !withLoading
            ? placeholderImage
            : Container(
                width: width,
                height: height,
                color: Colors.black12,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: progress != -1 ? progress : null,
                  ),
                ),
              );
      },
      errorWidget: (context, url, error) => placeholderImage,
    );
  }
}
