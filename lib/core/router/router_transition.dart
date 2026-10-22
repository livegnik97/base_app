import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'predictive_transitions.dart';

class RouterTransition {
  static Page _transitionPage({
    required LocalKey key,
    String? restorationId,
    required Widget child,
    TransitionType? type,
    bool? withParallax,
  }) => _PredictiveTransitionPage<void>(
    key: key,
    restorationId: restorationId,
    arguments: {
      'type': type,
      'withParallax': withParallax,
    },
    transitionType: type ?? TransitionType.none,
    withParallax: withParallax,
    child: child,
  );

  static Page fadeTransitionPage({
    required LocalKey key,
    String? restorationId,
    required Widget child,
    bool? withParallax,
  }) => _transitionPage(
    key: key,
    restorationId: restorationId,
    type: TransitionType.fade,
    withParallax: withParallax,
    child: child,
  );

  static Page scaleTransitionPage({
    required LocalKey key,
    String? restorationId,
    required Widget child,
    bool? withParallax,
  }) => _transitionPage(
    key: key,
    restorationId: restorationId,
    type: TransitionType.scale,
    withParallax: withParallax,
    child: child,
  );

  static Page rotationTransitionPage({
    required LocalKey key,
    String? restorationId,
    required Widget child,
    bool? withParallax,
  }) => _transitionPage(
    key: key,
    restorationId: restorationId,
    type: TransitionType.rotation,
    withParallax: withParallax,
    child: child,
  );

  static Page zoomFadeTransitionPage({
    required LocalKey key,
    String? restorationId,
    required Widget child,
    bool? withParallax,
  }) => _transitionPage(
    key: key,
    restorationId: restorationId,
    type: TransitionType.zoomFade,
    withParallax: withParallax,
    child: child,
  );

  static Page iosTransitionPage({
    required LocalKey key,
    String? restorationId,
    required Widget child,
    bool? withParallax,
  }) => _transitionPage(
    key: key,
    restorationId: restorationId,
    type: TransitionType.ios,
    withParallax: withParallax,
    child: child,
  );

  static Page slideTransitionPageX({
    required LocalKey key,
    String? restorationId,
    required Widget child,
    bool? withParallax,
  }) => _transitionPage(
    key: key,
    restorationId: restorationId,
    type: TransitionType.slideX,
    withParallax: withParallax,
    child: child,
  );

  static Page slideTransitionPageXInverse({
    required LocalKey key,
    String? restorationId,
    required Widget child,
    bool? withParallax,
  }) => _transitionPage(
    key: key,
    restorationId: restorationId,
    type: TransitionType.slideXInverse,
    withParallax: withParallax,
    child: child,
  );

  static Page slideTransitionPageY({
    required LocalKey key,
    String? restorationId,
    required Widget child,
    bool? withParallax,
  }) => _transitionPage(
    key: key,
    restorationId: restorationId,
    type: TransitionType.slideY,
    withParallax: withParallax,
    child: child,
  );

  static Page slideTransitionPageYInverse({
    required LocalKey key,
    String? restorationId,
    required Widget child,
    bool? withParallax,
  }) => _transitionPage(
    key: key,
    restorationId: restorationId,
    type: TransitionType.slideYInverse,
    withParallax: withParallax,
    child: child,
  );

  static Page slideTransitionPageXWithFade({
    required LocalKey key,
    String? restorationId,
    required Widget child,
    bool? withParallax,
  }) => _transitionPage(
    key: key,
    restorationId: restorationId,
    type: TransitionType.slideXWithFade,
    withParallax: withParallax,
    child: child,
  );

  static Page slideTransitionPageXInverseWithFade({
    required LocalKey key,
    String? restorationId,
    required Widget child,
    bool? withParallax,
  }) => _transitionPage(
    key: key,
    restorationId: restorationId,
    type: TransitionType.slideXInverseWithFade,
    withParallax: withParallax,
    child: child,
  );

  static Page slideTransitionPageYWithFade({
    required LocalKey key,
    String? restorationId,
    required Widget child,
    bool? withParallax,
  }) => _transitionPage(
    key: key,
    restorationId: restorationId,
    type: TransitionType.slideYWithFade,
    withParallax: withParallax,
    child: child,
  );

  static Page slideTransitionPageYInverseWithFade({
    required LocalKey key,
    String? restorationId,
    required Widget child,
    bool? withParallax,
  }) => _transitionPage(
    key: key,
    restorationId: restorationId,
    type: TransitionType.slideYInverseWithFade,
    withParallax: withParallax,
    child: child,
  );

  static Page noTransitionPage({
    required LocalKey key,
    String? restorationId,
    required Widget child,
  }) => NoTransitionPage<void>(
    key: key,
    restorationId: restorationId,
    child: child,
  );
}

/// Página customizada que expone su [DelegatedTransitionBuilder] para que la
/// ruta que queda DETRÁS se anime con el tipo de la que ENTRA.
class _PredictiveTransitionPage<T> extends Page<T> {
  const _PredictiveTransitionPage({
    super.key,
    super.restorationId,
    super.arguments,
    required this.child,
    required this.transitionType,
    required this.withParallax,
  });

  final Widget child;
  final TransitionType transitionType;
  final bool? withParallax;

  @override
  Route<T> createRoute(BuildContext context) =>
      _PredictiveTransitionPageRoute<T>(
        context: context,
        page: this,
      );
}

class _PredictiveTransitionPageRoute<T> extends MaterialPageRoute<T> {
  _PredictiveTransitionPageRoute({
    required BuildContext context,
    required _PredictiveTransitionPage<T> page,
  }) : super(
         settings: page,
         builder: (BuildContext context) => page.child,
       );

  _PredictiveTransitionPage<T> get _page =>
      settings as _PredictiveTransitionPage<T>;

  @override
  DelegatedTransitionBuilder? get delegatedTransition {
    if (_page.withParallax == false) {
      return null;
    }
    return delegatedTransitionFor(_page.transitionType);
  }

  @override
  void handleCommitBackGesture() {
    // El commit del framework (TransitionRoute._handleDragEnd) hace:
    //   context.pop();
    //   if (isAnimating) _controller.reverse(from: upperBound);
    // Ese `reverse(from: 1.0)` hace que la ruta "brinque" al inicio y vuelva a
    // animar toda la salida, en vez de continuar desde donde se soltó el dedo.
    // Aquí solo pop(): el didPop revierte el controller desde su valor actual,
    // así la transición continúa fluida desde la posición del gesto.
    navigator?.pop();
    // Cerrar el ciclo del userGesture (didStartUserGesture ya se registró al
    // iniciar el gesto). Mismo patrón que el tail de _handleDragEnd.
    if (controller?.isAnimating ?? false) {
      late final AnimationStatusListener listener;
      listener = (AnimationStatus status) {
        navigator?.didStopUserGesture();
        controller!.removeStatusListener(listener);
      };
      controller!.addStatusListener(listener);
    } else {
      navigator?.didStopUserGesture();
    }
  }
}
