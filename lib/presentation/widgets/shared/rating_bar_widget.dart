import 'package:flutter/material.dart';
import 'package:base_app/presentation/widgets/containers/custom_container.dart';

class RatingBarWidget extends StatelessWidget {
  final double? rating;
  final int? totalReviews;
  final int? totalReviews1;
  final int? totalReviews2;
  final int? totalReviews3;
  final int? totalReviews4;
  final int? totalReviews5;
  final int? totalFavorites;

  const RatingBarWidget({
    super.key,
    required this.rating,
    required this.totalReviews,
    required this.totalReviews1,
    required this.totalReviews2,
    required this.totalReviews3,
    required this.totalReviews4,
    required this.totalReviews5,
    required this.totalFavorites,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Determinamos si mostramos el estado "vacío" o con datos
    final bool hasData = (totalReviews ?? 0) > 0;

    return CustomContainer(
      padding: const EdgeInsets.all(24),
      color: isDark
          ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.1)
          : Colors.white,
      border: Border.all(
        color: colorScheme.outlineVariant.withValues(alpha: 0.2),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.05),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: Row(
          key: ValueKey<bool>(
            hasData,
          ), // Clave para que AnimatedSwitcher detecte el cambio
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- PARTE IZQUIERDA ---
            _buildLeftColumn(context, theme, colorScheme),

            const SizedBox(width: 32),

            // --- PARTE DERECHA (BARRAS) ---
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildAnimatedRow(context, 5, totalReviews5 ?? 0),
                  _buildAnimatedRow(context, 4, totalReviews4 ?? 0),
                  _buildAnimatedRow(context, 3, totalReviews3 ?? 0),
                  _buildAnimatedRow(context, 2, totalReviews2 ?? 0),
                  _buildAnimatedRow(context, 1, totalReviews1 ?? 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftColumn(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ANIMACIÓN 2: El número de rating cambia con un pequeño fade
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            rating?.toStringAsFixed(1) ?? '0',
            key: ValueKey<double>(rating ?? 0),
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -2,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        if (rating != null)
          Row(
            children: List.generate(5, (index) {
              int fullStars = rating!.floor();
              bool hasHalfStar = (rating! - fullStars) >= 0.5;

              if (index < fullStars) {
                // Estrella completa
                return Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 20,
                );
              } else if (hasHalfStar && index == fullStars) {
                // Media estrella
                return Icon(
                  Icons.star_half,
                  color: Colors.amber,
                  size: 20,
                );
              } else {
                // Estrella vacía (contorno)
                return Icon(
                  Icons.star_outline_rounded,
                  color: colorScheme.onSurface.withValues(alpha: 0.2),
                  size: 20,
                );
              }
            }),
          ),
        const SizedBox(height: 12),
        Text(
          '$totalReviews reseñas',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
        // Badge de favoritos minimalista
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        //   decoration: BoxDecoration(
        //     color: colorScheme.primary.withValues(alpha: 0.05),
        //     borderRadius: BorderRadius.circular(12),
        //   ),
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Icon(Icons.favorite, size: 14, color: colorScheme.primary),
        //       const SizedBox(width: 6),
        //       Text(
        //         totalFavorites.toString(),
        //         style: theme.textTheme.labelMedium?.copyWith(
        //           fontWeight: FontWeight.bold,
        //           color: colorScheme.primary,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Widget _buildAnimatedRow(BuildContext context, int stars, int count) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Cálculo de porcentaje
    double percentage = totalReviews == 0 ? 0.0 : count / (totalReviews ?? 0);
    String label = "${(percentage * 100).toStringAsFixed(0)}%";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(
            stars.toString(),
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.star_rounded, size: 14, color: Colors.amber[600]),
          const SizedBox(width: 12),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    // Fondo de la barra
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: colorScheme.onSurface.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    // ANIMACIÓN 3: La barra crece sola gracias a AnimatedContainer
                    AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastOutSlowIn,
                      height: 8,
                      width: constraints.maxWidth * percentage,
                      decoration: BoxDecoration(
                        color: percentage > 0
                            ? Colors.amber[600]
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          if (percentage > 0.1)
                            BoxShadow(
                              color: Colors.amber.withValues(alpha: 0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          // Porcentaje animado al cambiar texto
          SizedBox(
            width: 35,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                label,
                key: ValueKey<String>(label),
                textAlign: TextAlign.end,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
