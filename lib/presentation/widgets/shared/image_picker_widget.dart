import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:base_app/core/extensions/custom_context.dart';

/// Widget reutilizable para seleccionar o capturar una imagen.
///
/// Muestra un placeholder con icono de cámara. Al tocar, abre un bottom sheet
/// para elegir entre galería o cámara. El [File] seleccionado se devuelve
/// a través del callback [onImageSelected].
///
/// Si [imageFile] no es null, se muestra la preview de la imagen seleccionada.
class ImagePickerWidget extends StatelessWidget {
  const ImagePickerWidget({
    super.key,
    required this.onImageSelected,
    this.imageFile,
    this.imageUrl,
    this.height = 180,
    this.label = 'Agregar imagen',
    this.hint = 'Formato cuadrado recomendado',
  });

  /// Callback que devuelve el [File] elegido.
  final ValueChanged<File> onImageSelected;

  /// Imagen ya seleccionada (muestra preview local).
  final File? imageFile;

  /// URL de imagen existente (p. ej. al editar un producto).
  final String? imageUrl;

  final double height;
  final String label;
  final String hint;

  Future<void> _pick(BuildContext context, ImageSource source) async {
    context.pop(); // cierra el bottom sheet
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 85);
    if (picked != null) {
      onImageSelected(File(picked.path));
    }
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: context.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Seleccionar de galería'),
                onTap: () => _pick(ctx, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Tomar foto'),
                onTap: () => _pick(ctx, ImageSource.camera),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    Widget child;

    if (imageFile != null) {
      child = ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          imageFile!,
          width: double.infinity,
          height: height,
          fit: BoxFit.cover,
        ),
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      child = ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          imageUrl!,
          width: double.infinity,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _Placeholder(
            colorScheme: colorScheme,
            theme: theme,
            height: height,
            label: label,
            hint: hint,
          ),
        ),
      );
    } else {
      child = _Placeholder(
        colorScheme: colorScheme,
        theme: theme,
        height: height,
        label: label,
        hint: hint,
      );
    }

    return GestureDetector(
      onTap: () => _showPicker(context),
      child: child,
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({
    required this.colorScheme,
    required this.theme,
    required this.height,
    required this.label,
    required this.hint,
  });

  final ColorScheme colorScheme;
  final ThemeData theme;
  final double height;
  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedBorderPainter(
        color: Colors.black,
        strokeWidth: 1,
        dashWidth: 5,
        dashGap: 3,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_outlined, color: Colors.black, size: 24),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// CustomPainter para dibujar bordes discontinuos sin paquetes externos
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashGap;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashGap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    const radius = 4.0; // Mismo radio que el BorderRadius
    path.addRRect(
      RRect.fromLTRBAndCorners(
        0,
        0,
        size.width,
        size.height,
        topLeft: const Radius.circular(radius),
        topRight: const Radius.circular(radius),
        bottomLeft: const Radius.circular(radius),
        bottomRight: const Radius.circular(radius),
      ),
    );

    final Path dashedPath = Path();
    for (PathMetric pathMetric in path.computeMetrics()) {
      double distance = 0;
      bool draw = true;
      while (distance < pathMetric.length) {
        final double length = draw ? dashWidth : dashGap;
        dashedPath.addPath(
          pathMetric.extractPath(distance, distance + length),
          Offset.zero,
        );
        distance += length;
        draw = !draw;
      }
    }
    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
