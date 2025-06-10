import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> hasStoragePermission() async {
  final DeviceInfoPlugin info = DeviceInfoPlugin();
  final AndroidDeviceInfo androidInfo = await info.androidInfo;
  final int androidVersion = int.parse(androidInfo.version.release);

  if (androidVersion >= 13) {
    // For Android 13+, use granular media permissions
    final status = await Permission.manageExternalStorage.status;
    if (status.isGranted) {
      return true;
    } else {
      final result = await Permission.manageExternalStorage.request();
      if (result.isGranted) {
        return true;
      } else {
        // Handle permission denied
        return false;
      }
    }
  } else {
    // For older Android versions, use the old READ_EXTERNAL_STORAGE
    final status = await Permission.storage.status;
    if (status.isGranted) {
      return true;
    } else {
      final result = await Permission.storage.request();
      if (result.isGranted) {
        return true;
      } else {
        // Handle permission denied
        return false;
      }
    }
  }
}

Future<bool> getPermission(Permission permission) async {
  var checkStatus = await permission.status;

  if (checkStatus.isGranted) {
    return true;
  } else {
    var status = await permission.request();
    if (status.isGranted) {
    } else if (status.isDenied) {
      getPermission(permission);
    } else {
      openAppSettings();
      // EasyLoading.showError('Allow the permission');
    }
    return false;
  }
}
