import 'package:base_app/core/helpers/image_manager/widgets/image_crop_page.dart';
import 'package:base_app/presentation/modules/home/home.page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'router_path.dart';
import 'router_transition.dart';

//* routes
part "routes/auth_routes.dart";
part "routes/home_routes.dart";
part "routes/settings_routes.dart";
part "routes/utility_routes.dart";

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

final appRouter = GoRouter(
  initialLocation: RouterPath.HOME_PAGE,
  observers: [routeObserver],
  routes: [
    // GoRoute(
    //   path: RouterPath.SPLASH_PAGE,
    //   pageBuilder: (context, state) {
    //     return RouterTransition.fadeTransitionPage(
    //       key: state.pageKey,
    //       child: const SplashPage(),
    //     );
    //   },
    // ),
    ...authRoutes,
    ...homeRoutes,
    ...settingsRoutes,
    ...utilityRoutes,
  ],
);
