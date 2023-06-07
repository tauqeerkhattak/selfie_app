import 'dart:developer';
import 'dart:io';

import 'package:google_mlkit_selfie_segmentation/google_mlkit_selfie_segmentation.dart';

class GoogleMlService {
  final segmenter = SelfieSegmenter(
    mode: SegmenterMode.stream,
    enableRawSizeMask: true,
  );

  Future<SegmentationMask?> getSegmentedImage(File image) async {
    final inputImage = InputImage.fromFile(image);
    final mask = await segmenter.processImage(inputImage);
    log('MetaData: ${inputImage.metadata?.toJson()}');
    return mask;
  }

  Future<void> disposeSegmenter() async {
    await segmenter.close();
  }
}
