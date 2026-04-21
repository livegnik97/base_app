import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouterTransition {
  static Page fadeTransitionPage({
    required LocalKey key,
    String? restorationId,
    required Widget child,
    bool opaque = true,
  }) => CustomTransitionPage<void>(
    key: key,
    restorationId: restorationId,
    child: child,
    opaque: opaque,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );

  static Page scaleTransitionPage({
    required LocalKey key,
    String? restorationId,
    required Widget child,
    bool opaque = true,
  }) => CustomTransitionPage<void>(
    key: key,
    restorationId: restorationId,
    child: child,
    opaque: opaque,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        ScaleTransition(scale: animation, child: child),
  );

  static Page rotationTransitionPage({
    required LocalKey key,
    String? restorationId,
    required Widget child,
    bool opaque = true,
  }) => CustomTransitionPage<void>(
    key: key,
    restorationId: restorationId,
    child: child,
    opaque: opaque,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        RotationTransition(turns: animation, child: child),
  );

  static Page slideTransitionPageX({
    required LocalKey key,
    String? restorationId,
    required Widget child,
    bool opaque = true,
  }) => CustomTransitionPage<void>(
    key: key,
    restorationId: restorationId,
    child: child,
    opaque: opaque,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        SlideTransition(
          position: animation.drive(
            Tween<Offset>(
              begin: const Offset(0.25, 0.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.linearToEaseOut)),
          ),
          child: child,
        ),
  );

  static Page slideTransitionPageY({
    required LocalKey key,
    String? restorationId,
    required Widget child,
    bool opaque = true,
  }) => CustomTransitionPage<void>(
    key: key,
    restorationId: restorationId,
    child: child,
    opaque: opaque,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        SlideTransition(
          position: animation.drive(
            Tween<Offset>(
              begin: const Offset(0.0, 0.5),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.linearToEaseOut)),
          ),
          child: child,
        ),
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
