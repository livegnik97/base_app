part of "../router.dart";

final homeRoutes = [
  GoRoute(
    path: RouterPath.HOME_PAGE,
    pageBuilder: (context, state) {
      return RouterTransition.fadeTransitionPage(
        key: state.pageKey,
        child: const HomePage(),
      );
    },
  ),
];
