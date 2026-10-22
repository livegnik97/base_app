import 'dart:io';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:go_router/go_router.dart';
import 'package:base_app/core/constants/hero_tags.dart';
import 'package:base_app/core/extensions/custom_context.dart';
import 'package:base_app/core/router/router_path.dart';
import 'package:base_app/presentation/widgets/buttons/custom_filled_button.dart';
import 'package:base_app/presentation/widgets/buttons/custom_icon_button.dart';
import 'package:base_app/presentation/widgets/shared/custom_loading_widget.dart';
import 'package:path_provider/path_provider.dart';

class ImageCropPage extends StatefulWidget {
  const ImageCropPage({super.key, required this.originalPath});
  final String originalPath;

  @override
  State<ImageCropPage> createState() => _ImageCropPageState();

  static Future<String?> show(
    BuildContext context, {
    required String originalPath,
  }) {
    return context.push(
      RouterPath.CROP_IMAGE_PAGE,
      extra: originalPath,
    );
  }
}

class _ImageCropPageState extends State<ImageCropPage> {
  final CustomImageCropController controller = CustomImageCropController();

  bool isCropping = false;
  bool isExit = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (canPop, _) {
        if (!isCropping) {
          exit(context);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Hero(
              tag: HeroTags.myProfilePhoto,
              child: CustomImageCrop(
                cropController: controller,
                image: FileImage(File(widget.originalPath)),
                canRotate: false,
                canMove: !isCropping,
                canScale: !isCropping,
                forceInsideCropArea: true,
                // shape: CustomCropShape.Square,
                // imageFit: CustomImageFit.fitVisibleSpace,
                customProgressIndicator: const CustomLoadingWidget(),
                cropPercentage: .6,
                clipShapeOnCrop: false,
                backgroundColor: Colors.black,
                // ratio: Ratio(width: 1, height: .7),
              ),
            ),
            isCropping == true
                ? Center(child: ZoomIn(child: CustomLoadingWidget()))
                : Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: FadeInUp(
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CustomFilledButton(
                                label: context.l10n.cancel,
                                onPressed: isCropping == true
                                    ? null
                                    : () {
                                        exit(context);
                                      },
                              ),
                              CustomIconButton(
                                icon: Icons.rotate_right,
                                iconButtonType: IconButtonType.filled,
                                onPressed: isCropping == true
                                    ? null
                                    : () => controller.addTransition(
                                        CropImageData(angle: pi / 2),
                                      ),
                              ),
                              CustomFilledButton(
                                label: 'Recortar',
                                onPressed: isCropping == true
                                    ? null
                                    : () async {
                                        isCropping = true;
                                        final image = await controller
                                            .onCropImage();
                                        if (image != null) {
                                          //* Comprimir
                                          final result =
                                              await FlutterImageCompress.compressWithList(
                                                image.bytes,
                                                quality: 50,
                                              );
                                          //* Guardar
                                          final tempDir =
                                              await getTemporaryDirectory();
                                          final name =
                                              "image-${DateTime.now().millisecondsSinceEpoch}.jpg";
                                          final path = '${tempDir.path}/$name';
                                          final file = await File(
                                            path,
                                          ).create();
                                          file.writeAsBytesSync(result);
                                          if (context.mounted) {
                                            exit(context, path);
                                          }
                                        } else {
                                          isCropping = false;
                                          //* Ha ocurrido un error
                                        }
                                      },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void exit(BuildContext context, [String? result]) {
    try {
      if (context.mounted == false || isExit) return;
      isExit = true;
      context.pop(result);
    } catch (_) {}
  }
}
