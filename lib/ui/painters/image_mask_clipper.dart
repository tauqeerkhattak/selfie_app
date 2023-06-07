import 'package:flutter/material.dart';
import 'package:google_mlkit_selfie_segmentation/google_mlkit_selfie_segmentation.dart';

class ImageMaskClipper extends CustomClipper<Path> {
  final SegmentationMask mask;

  ImageMaskClipper({
    required this.mask,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final points = mask.confidences;
    final width = mask.width;
    final height = mask.height;
    int confidenceCounter = 0;
    for (int h = 0; h < height; h++) {
      for (int w = 0; w < width; w++) {
        final opacity = points[confidenceCounter] * 0.25;
        if (opacity > 0.19) {
          path.addOval(
            Rect.fromCircle(
              center: Offset(
                w.toDouble() * size.width / width,
                h.toDouble() * size.height / height,
              ),
              radius: 1,
            ),
          );
          // path.addRect(
          //
          // );
        }
        // canvas.dr
        confidenceCounter++;
      }
    }
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<dynamic> oldClipper) {
    return false;
  }
}
