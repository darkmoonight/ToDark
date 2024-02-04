import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:todark/app/data/schema.dart';
import 'package:todark/main.dart';

class IsarController {
  var now = DateTime.now();

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationSupportDirectory();

      return isar = await Isar.open(
        [
          TasksSchema,
          TodosSchema,
          SettingsSchema,
        ],
        directory: dir.path,
        inspector: true,
      );
    }

    return Future.value(Isar.getInstance());
  }

  Future<void> createBackUp() async {
    final backUpDir = await FilePicker.platform.getDirectoryPath();

    if (backUpDir == null) {
      EasyLoading.showInfo('errorPath'.tr);
      return;
    }

    try {
      final timeStamp = DateFormat('yyyyMMdd_HHmmss').format(now);

      final backupFileName = 'backup_todark_db$timeStamp.isar';

      final File backUpFile = File('$backUpDir/$backupFileName');
      if (await backUpFile.exists()) {
        await backUpFile.delete();
      }

      await isar.copyToFile('$backUpDir/$backupFileName');
      EasyLoading.showSuccess('successBackup'.tr);
    } catch (e) {
      EasyLoading.showError('error'.tr);
      return Future.error(e);
    }
  }

  Future<void> restoreDB() async {
    final dbDirectory = await getApplicationSupportDirectory();
    final backupDirectory = await FilePicker.platform.pickFiles();

    if (backupDirectory == null) {
      EasyLoading.showInfo('errorPathRe'.tr);
      return;
    }

    try {
      await isar.close();

      final dbFile = File('${backupDirectory.files.single.path}');
      final dbPath = p.join(dbDirectory.path, 'default.isar');

      if (await dbFile.exists()) {
        await dbFile.copy(dbPath);
      }
      EasyLoading.showSuccess('successRestoreCategory'.tr);
      Future.delayed(const Duration(milliseconds: 500), () => Restart.restartApp());
    } catch (e) {
      EasyLoading.showError('error'.tr);
      return Future.error(e);
    }
  }
}
