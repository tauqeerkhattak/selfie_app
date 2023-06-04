import 'package:flutter/material.dart';
import 'package:google_mlkit_selfie_segmentation/google_mlkit_selfie_segmentation.dart';

class ImageMaskPainter extends CustomPainter {
  final SegmentationMask mask;

  ImageMaskPainter({
    required this.mask,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final points = mask.confidences;
    final width = mask.width;
    final height = mask.height;
    final paint = Paint();
    const maskColor = Colors.pink;
    int confidenceCounter = 0;
    for (int h = 0; h < height; h++) {
      for (int w = 0; w < width; w++) {
        final opacity = points[confidenceCounter] * 0.25;
        canvas.drawCircle(
          Offset(
            w.toDouble() * size.width / width,
            h.toDouble() * size.height / height,
          ),
          1,
          paint..color = maskColor.withOpacity(opacity),
        );
        // canvas.dr
        confidenceCounter++;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
