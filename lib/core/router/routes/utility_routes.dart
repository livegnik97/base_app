part of "../router.dart";

final utilityRoutes = [
  GoRoute(
    path: RouterPath.CROP_IMAGE_PAGE,
    pageBuilder: (context, state) {
      final originalPath = state.extra as String;
      return RouterTransition.slideTransitionPageX(
        key: state.pageKey,
        child: ImageCropPage(
          originalPath: originalPath,
        ),
      );
    },
  ),
];
