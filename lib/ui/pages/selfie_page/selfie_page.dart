import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_selfie_segmentation/google_mlkit_selfie_segmentation.dart';
import 'package:image/image.dart' as img;
import 'package:selfie_app/services/google_ml_service.dart';
import 'package:selfie_app/ui/painters/image_mask_clipper.dart';
import 'package:selfie_app/ui/painters/image_mask_painter.dart';
import 'package:selfie_app/ui/widgets/loader.dart';

import '../../../services/locator.dart';

Future<void> getClippedImage(String path, SegmentationMask mask) async {
  final file = File(path);
  final image = img.decodeImage(file.readAsBytesSync());
  if (image != null) {
    final pixels = image.toList();
    final width = image.width;
    final height = image.height;
    final maskWidth = image.width;
    final maskHeight = mask.height;
    final confidences = mask.confidences;
    for (final confidence in confidences) {
      final pixelWidth = (confidence * width) / maskWidth;
      final pixelHeight = (confidence * height) / maskHeight;
      final pixel = (pixelHeight * pixelWidth).toInt();
      if (pixel > pixels.length) {
        print('Pixel is out of bound!');
      }
    }
    print('No pixel is out of bound!');
  }
}

class SelfiePage extends StatefulWidget {
  final File file;
  const SelfiePage({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  State<SelfiePage> createState() => _SelfiePageState();
}

Future<void> abc(String message) async {
  await Future.delayed(
    const Duration(seconds: 5),
    () => print(message),
  );
}

class _SelfiePageState extends State<SelfiePage> {
  bool loading = false;
  SegmentationMask? _mask;

  Future<void> getSegmentation() async {
    loading = true;
    final mask =
        await locator<GoogleMlService>().getSegmentedImage(widget.file);
    _mask = mask;
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getSegmentation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selfie App'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await compute<String, void>(abc, 'Hello');
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (loading) {
      return const Loader();
    } else if (_mask != null) {
      return _buildImageView();
    } else {
      return _buildInitialView();
    }
  }

  Widget _buildImageView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: LongPressDraggable<File>(
          data: widget.file,
          feedback: SizedBox(
            width: _mask!.width.toDouble(),
            height: _mask!.height.toDouble(),
            child: Center(
              child: ClipPath(
                clipper: ImageMaskClipper(
                  mask: _mask!,
                ),
                child: Image.file(
                  widget.file,
                  // scale: ,
                ),
              ),
            ),
          ),
          child: CustomPaint(
            foregroundPainter: ImageMaskPainter(
              mask: _mask!,
            ),
            child: Image.file(
              widget.file,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInitialView() {
    return const Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        'No image selected, please select an image from one of the options below!',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
