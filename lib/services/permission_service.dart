import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<PermissionStatus> requestStorage() async {
    return await Permission.storage.request();
  }

  Future<PermissionStatus> getStorageStatus() async {
    return await Permission.storage.status;
  }
}
