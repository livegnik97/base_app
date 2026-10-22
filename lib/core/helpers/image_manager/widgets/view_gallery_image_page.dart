import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:base_app/presentation/widgets/shared/custom_bottom_dots_page.dart';

import 'view_image_page.dart';

class ImageItem {
  final String path;
  final String? heroTag;
  final ExtendedImageType extendedImageType;
  ImageItem({
    required this.path,
    this.heroTag,
    this.extendedImageType = ExtendedImageType.network,
  });
}

class ViewGalleryImagePage extends StatefulWidget {
  const ViewGalleryImagePage({
    super.key,
    this.initialPage = 0,
    required this.imagesItem,
    this.onChangedPage,
  });

  final int initialPage;
  final List<ImageItem> imagesItem;
  final void Function(int)? onChangedPage;

  @override
  State<ViewGalleryImagePage> createState() => _ViewGalleryImagePageState();
}

class _ViewGalleryImagePageState extends State<ViewGalleryImagePage> {
  late PageController pageController;
  late int currentPage;

  @override
  void initState() {
    super.initState();
    currentPage = widget.initialPage;
    pageController = PageController(initialPage: widget.initialPage);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: pageController,
          children: widget.imagesItem.map((imageItem) {
            return ViewImagePage(
              imagePath: imageItem.path,
              showBtnClose: false,
              heroTag: imageItem.heroTag,
              extendedImageType: imageItem.extendedImageType,
            );
          }).toList(),
          onPageChanged: (value) {
            setState(() {
              widget.onChangedPage?.call(value);
              currentPage = value;
            });
          },
        ),
        Positioned(
          right: 8,
          top: 0,
          child: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade900.withAlpha(100),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: context.pop,
                icon: const Icon(Icons.close_outlined, color: Colors.white),
              ),
            ),
          ),
        ),
        if (widget.imagesItem.length > 1)
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: SafeArea(
              child: CustomBottomDotsPage(
                currentPage: currentPage,
                totalPages: widget.imagesItem.length,
              ),
            ),
          ),
        // Positioned(
        //   left: 8,
        //   top: 0,
        //   child: SafeArea(
        //     child: Container(
        //       decoration: BoxDecoration(
        //         color: Colors.grey.shade900.withAlpha(100),
        //         borderRadius: BorderRadius.circular(8),
        //       ),
        //       child: Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: Text(
        //           "${currentPage + 1}/${widget.imagesItem.length}",
        //           style: context.titleLarge.copyWith(color: Colors.white),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
