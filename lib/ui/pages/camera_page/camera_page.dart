import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../widgets/loader.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  List<CameraDescription> _cameras = [];
  late CameraController _controller;

  Future<void> getCameras() async {
    _cameras = await availableCameras();
    _controller = CameraController(
      _cameras[0],
      enableAudio: false,
      ResolutionPreset.max,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    await _controller.initialize();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCameras();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_cameras.isEmpty) {
      return const Loader();
    } else if (_cameras.isNotEmpty && !_controller.value.isInitialized) {
      return const Center(
        child: Text(
          'Something went wrong with initializing camera!',
        ),
      );
    } else {
      return SizedBox(
        height: double.infinity,
        child: CameraPreview(_controller),
      );
    }
  }
}
