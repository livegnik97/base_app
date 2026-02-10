import 'package:base_app/presentation/modules/home/home_page.dart';
import 'package:go_router/go_router.dart';

import 'router_path.dart';
import 'router_transition.dart';

//* routes
part "routes/auth_routes.dart";
part "routes/home_routes.dart";
part "routes/settings_routes.dart";

final appRouter = GoRouter(
  initialLocation: RouterPath.HOME_PAGE,
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
  ],
);
