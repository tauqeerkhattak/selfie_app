import 'dart:developer';
import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:selfie_app/services/locator.dart';
import 'package:selfie_app/ui/pages/selfie_page/selfie_page.dart';
import 'package:selfie_app/utils/file_system_utils.dart';

import '../../../services/google_ml_service.dart';
import '../../../services/permission_service.dart';

class FilesPage extends StatefulWidget {
  const FilesPage({Key? key}) : super(key: key);

  @override
  State<FilesPage> createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  PermissionStatus? status;
  final _controller = FileManagerController();

  Future<void> getStoragePermission() async {
    status = await locator<PermissionService>().requestStorage();
    setState(() {});
  }

  Future<bool> _onBackPressed() async {
    await _controller.goToParentDirectory();
    return false;
  }

  Future<void> _onFolderTapped(FileSystemEntity file) async {
    final isFile = FileManager.isFile(file);
    if (!isFile) {
      _controller.openDirectory(file);
    } else {
      log('Not a file!');
    }
  }

  @override
  void initState() {
    super.initState();
    getStoragePermission();
  }

  @override
  void dispose() {
    locator<GoogleMlService>().disposeSegmenter();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (status == PermissionStatus.granted) {
      return FileManager(
        controller: _controller,
        hideHiddenEntity: true,
        builder: (context, files) {
          return _buildFiles(files);
        },
      );
    } else {
      return const Center(
        child: Text('Permission not granted!'),
      );
    }
  }

  Widget _buildFiles(List<FileSystemEntity> files) {
    if (files.isNotEmpty) {
      return MasonryGridView.count(
        crossAxisCount: 2,
        itemCount: files.length,
        itemBuilder: (context, index) {
          final file = files[index];
          return _buildFileView(file);
        },
      );
    } else {
      return const Center(
        child: Text('No files found!'),
      );
    }
  }

  Widget _buildFileView(FileSystemEntity file) {
    final isFile = FileManager.isFile(file);
    if (file.isImage()) {
      return InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelfiePage(
              file: File(file.path),
            ),
          ),
        ),
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(5),
          width: double.infinity,
          height: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(
                File(
                  file.path,
                ),
              ),
              filterQuality: FilterQuality.low,
              isAntiAlias: false,
              fit: BoxFit.fill,
            ),
          ),
          alignment: Alignment.bottomLeft,
          child: Text(file.getName()),
        ),
      );
    } else if (!isFile) {
      return Card(
        child: ListTile(
          title: Text(
            file.getName(),
          ),
          leading: const Icon(
            Icons.folder,
          ),
          onTap: () => _onFolderTapped(file),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
