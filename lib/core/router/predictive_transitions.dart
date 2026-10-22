import 'package:flutter/cupertino.dart' show CupertinoPageTransition;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum TransitionType {
  fade,
  scale,
  zoomFade,
  rotation,
  slideX,
  slideXInverse,
  slideY,
  slideYInverse,
  slideXWithFade,
  slideXInverseWithFade,
  slideYWithFade,
  slideYInverseWithFade,
  ios,
  none,
}

class MultiTransicionPredictivaBuilder extends PageTransitionsBuilder {
  const MultiTransicionPredictivaBuilder();

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    late TransitionType type;
    bool? withParallax;
    if (route.settings.arguments is TransitionType) {
      type = route.settings.arguments as TransitionType;
    } else if (route.settings.arguments is Map<String, dynamic>) {
      final map = route.settings.arguments as Map<String, dynamic>;
      type = map['type'] as TransitionType? ?? TransitionType.none;
      withParallax = map['withParallax'] as bool?;
    } else {
      type = TransitionType.none;
    }
    withParallax ??= type != TransitionType.ios && type != TransitionType.none;
    return _PredictiveBackGestureDetector(
      route: route as PageRoute<dynamic>,
      child: _buildTransition(
        route: route,
        type: type,
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        child: child,
        withParallax: withParallax,
      ),
    );
  }
}

/// Aplica a la ruta que queda DETRÁS un movimiento paralelo que es el
/// "inverso" de su propia transición:
///  * slideX  -> la de atrás se desliza hacia la izquierda (paralelo a iOS)
///  * slideY  -> se desliza hacia arriba
///  * fade    -> se atenúa (se oscurece) mientras queda tapada
///  * zoom/scale -> se encoge un poco al ser tapada
///  * rotation -> rota suavemente
/// En un Pop, la pantalla de atrás vuelve acompañando el gesto.
Widget _withSecondaryParallax({
  required TransitionType type,
  required Animation<double> secondaryAnimation,
  required Widget child,
}) {
  switch (type) {
    case TransitionType.slideX:
    case TransitionType.slideXWithFade:
      return _secondarySlide(
        secondaryAnimation: secondaryAnimation,
        end: const Offset(-0.35, 0.0),
        child: child,
      );
    case TransitionType.slideXInverse:
    case TransitionType.slideXInverseWithFade:
      return _secondarySlide(
        secondaryAnimation: secondaryAnimation,
        end: const Offset(0.35, 0.0),
        child: child,
      );
    case TransitionType.slideY:
    case TransitionType.slideYWithFade:
      return _secondarySlide(
        secondaryAnimation: secondaryAnimation,
        end: const Offset(0.0, -0.35),
        child: child,
      );
    case TransitionType.slideYInverse:
    case TransitionType.slideYInverseWithFade:
      return _secondarySlide(
        secondaryAnimation: secondaryAnimation,
        end: const Offset(0.0, 0.35),
        child: child,
      );
    case TransitionType.scale:
      return ScaleTransition(
        scale: secondaryAnimation.drive(
          Tween<double>(begin: 1.0, end: 0.88).chain(
            CurveTween(curve: Curves.linearToEaseOut),
          ),
        ),
        child: child,
      );
    case TransitionType.zoomFade:
      return FadeTransition(
        opacity: secondaryAnimation.drive(
          Tween<double>(begin: 1.0, end: 0.7).chain(
            CurveTween(curve: Curves.linearToEaseOut),
          ),
        ),
        child: ScaleTransition(
          scale: secondaryAnimation.drive(
            Tween<double>(begin: 1.0, end: 0.9).chain(
              CurveTween(curve: Curves.linearToEaseOut),
            ),
          ),
          child: child,
        ),
      );
    case TransitionType.rotation:
      return RotationTransition(
        turns: secondaryAnimation.drive(
          Tween<double>(begin: 0.0, end: -0.02).chain(
            CurveTween(curve: Curves.linearToEaseOut),
          ),
        ),
        child: child,
      );
    case TransitionType.fade:
      return FadeTransition(
        opacity: secondaryAnimation.drive(
          Tween<double>(begin: 1.0, end: 0.6).chain(
            CurveTween(curve: Curves.easeOut),
          ),
        ),
        child: child,
      );
    case TransitionType.ios:
    case TransitionType.none:
      return child;
    // return _secondarySlide(
    //   secondaryAnimation: secondaryAnimation,
    //   end: const Offset(-0.5, 0.0),
    //   child: child,
    // );
  }
}

Widget _secondarySlide({
  required Animation<double> secondaryAnimation,
  required Offset end,
  required Widget child,
}) {
  return SlideTransition(
    position: secondaryAnimation.drive(
      Tween<Offset>(begin: Offset.zero, end: end).chain(
        CurveTween(curve: Curves.linearToEaseOut),
      ),
    ),
    child: child,
  );
}

Widget _buildTransition({
  required PageRoute<dynamic> route,
  required TransitionType type,
  required Animation<double> animation,
  required Animation<double> secondaryAnimation,
  required Widget child,
  required bool withParallax,
}) {
  if (type == TransitionType.ios) {
    return CupertinoPageTransition(
      primaryRouteAnimation: animation,
      secondaryRouteAnimation: secondaryAnimation,
      // Durante el gesto de back, se anima de forma lineal para que la
      // transición siga exactamente el dedo y arranque justo donde se suelta.
      linearTransition: route.popGestureInProgress,
      child: child,
    );
  }

  // El parallax se aplica a TODAS las rutas (incluida la shell, cuyo tipo es
  // `none`). Sólo se mueve cuando la ruta queda DEBJO de otra: su
  // `secondaryAnimation` va 0 -> 1 al ser tapada, y 1 -> 0 al ser
  // descubierta (gesto de back), igual que en iOS. Como ruta tope,
  // `secondaryAnimation` está en 0 y no se mueve.
  if (withParallax) {
    return _withSecondaryParallax(
      type: type,
      secondaryAnimation: secondaryAnimation,
      child: _buildPerspectiveTransition(animation, type, child),
    );
  }
  return _buildPerspectiveTransition(animation, type, child);
}

Widget _buildPerspectiveTransition(
  Animation<double> animation,
  TransitionType tipo,
  Widget child,
) {
  switch (tipo) {
    case TransitionType.fade:
      return FadeTransition(opacity: animation, child: child);
    case TransitionType.scale:
      return ScaleTransition(scale: animation, child: child);
    case TransitionType.zoomFade:
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: animation.drive(Tween<double>(begin: 0.8, end: 1.0)),
          child: child,
        ),
      );
    case TransitionType.rotation:
      return RotationTransition(turns: animation, child: child);
    case TransitionType.slideX:
      return _slideTransition(
        animation: animation,
        begin: const Offset(0.8, 0.0),
        child: child,
      );
    case TransitionType.slideXInverse:
      return _slideTransition(
        animation: animation,
        begin: const Offset(-0.8, 0.0),
        child: child,
      );
    case TransitionType.slideY:
      return _slideTransition(
        animation: animation,
        begin: const Offset(0.0, 0.5),
        child: child,
      );
    case TransitionType.slideYInverse:
      return _slideTransition(
        animation: animation,
        begin: const Offset(0.0, -0.5),
        child: child,
      );
    case TransitionType.slideXWithFade:
      return _slideTransition(
        animation: animation,
        begin: const Offset(0.8, 0.0),
        child: FadeTransition(opacity: animation, child: child),
      );
    case TransitionType.slideXInverseWithFade:
      return _slideTransition(
        animation: animation,
        begin: const Offset(-0.8, 0.0),
        child: FadeTransition(opacity: animation, child: child),
      );
    case TransitionType.slideYWithFade:
      return _slideTransition(
        animation: animation,
        begin: const Offset(0.0, 0.5),
        child: FadeTransition(opacity: animation, child: child),
      );
    case TransitionType.slideYInverseWithFade:
      return _slideTransition(
        animation: animation,
        begin: const Offset(0.0, -0.5),
        child: FadeTransition(opacity: animation, child: child),
      );
    case TransitionType.ios:
    case TransitionType.none:
      return child;
  }
}

Widget _slideTransition({
  required Animation<double> animation,
  required Offset begin,
  required Widget child,
}) {
  return SlideTransition(
    position: animation.drive(
      Tween<Offset>(begin: begin, end: Offset.zero).chain(
        CurveTween(curve: Curves.linearToEaseOut),
      ),
    ),
    child: child,
  );
}

/// Builder delegado para la ruta que ENTRA: define cómo se anima la ruta que
/// queda DETRÁS usando el TIPO DE LA QUE ENTRA (no el de la de atrás).
///
/// Flutter lleva el `secondaryAnimation` de la ruta de abajo sincronizado con
/// la animación de la ruta de arriba, así que aquí podemos reaccionar con la
/// transición que corresponda según `type` de la que entra.
DelegatedTransitionBuilder? delegatedTransitionFor(TransitionType type) {
  if (type == TransitionType.ios) {
    return CupertinoPageTransition.delegatedTransition;
  }
  return (
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    bool allowSnapshotting,
    Widget? child,
  ) {
    if (child == null) {
      return null;
    }
    return _withSecondaryParallax(
      type: type,
      secondaryAnimation: secondaryAnimation,
      child: child,
    );
  };
}

class _PredictiveBackGestureDetector extends StatefulWidget {
  const _PredictiveBackGestureDetector({
    required this.route,
    required this.child,
  });

  final PageRoute<dynamic> route;
  final Widget child;

  @override
  State<_PredictiveBackGestureDetector> createState() =>
      _PredictiveBackGestureDetectorState();
}

class _PredictiveBackGestureDetectorState
    extends State<_PredictiveBackGestureDetector>
    with WidgetsBindingObserver {
  bool get _isEnabled =>
      widget.route.isCurrent && widget.route.popGestureEnabled;

  @override
  bool handleStartBackGesture(PredictiveBackEvent backEvent) {
    final bool gestureInProgress = !backEvent.isButtonEvent && _isEnabled;
    if (!gestureInProgress) {
      return false;
    }

    widget.route.handleStartBackGesture(progress: 1 - backEvent.progress);
    return true;
  }

  @override
  void handleUpdateBackGestureProgress(PredictiveBackEvent backEvent) {
    widget.route.handleUpdateBackGestureProgress(
      progress: 1 - backEvent.progress,
    );
  }

  @override
  void handleCancelBackGesture() {
    widget.route.handleCancelBackGesture();
  }

  @override
  void handleCommitBackGesture() {
    widget.route.handleCommitBackGesture();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
