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
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    } else {
      final result = await Permission.manageExternalStorage.request();
      if (result.isGranted) {
        return true;
      } else if (result.isPermanentlyDenied) {
        await openAppSettings();
        return false;
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
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    } else {
      final result = await Permission.storage.request();
      if (result.isGranted) {
        return true;
      } else if (result.isPermanentlyDenied) {
        await openAppSettings();
        return false;
      } else {
        // Handle permission denied
        return false;
      }
    }
  }
}

Future<bool> getPermission(Permission permission) async {
  var status = await permission.status;

  if (status.isGranted) {
    return true;
  } else if (status.isPermanentlyDenied) {
    // The user opted to never ask again, direct to app settings
    await openAppSettings();
    return false;
  } else {
    var result = await permission.request();
    if (result.isGranted) {
      return true;
    } else if (result.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    } else {
      // Permission denied (but not permanently)
      return false;
    }
  }
}
