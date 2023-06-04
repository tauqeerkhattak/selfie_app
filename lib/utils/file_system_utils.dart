import 'dart:io';

import 'package:file_manager/file_manager.dart';

import 'commons.dart';

extension FileSystemUtils on FileSystemEntity {
  String getName() {
    final split = path.split('/');
    return split.last;
  }

  bool isImage() {
    final isNotDir = FileManager.isFile(this);
    if (isNotDir) {
      final extension = FileManager.getFileExtension(this);
      return Commons.imageExtensions.contains(extension);
    } else {
      return false;
    }
  }
}
