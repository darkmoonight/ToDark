import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:todark/app/data/schema.dart';
import 'package:todark/app/widgets/settings_card.dart';
import 'package:todark/main.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  late AndroidDeviceInfo androidInfo;
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      androidInfo = await deviceInfo.androidInfo;
    });
    super.initState();
  }

  void check(Function fun) async {
    try {
      var statusManageExternalStorage =
          await Permission.manageExternalStorage.request();

      if (statusManageExternalStorage.isGranted &&
          androidInfo.version.sdkInt > 29) {
        fun();
      } else if (androidInfo.version.sdkInt < 30) {
        fun();
      }
    } catch (e) {
      EasyLoading.showError('error'.tr);
      return Future.error(e);
    }
  }

  void backup() async {
    final dlPath = await FilePicker.platform.getDirectoryPath();

    if (dlPath == null) {
      EasyLoading.showInfo('errorPath'.tr);
      return;
    } else {
      try {
        final timeStamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());

        final taskFileName = 'task_$timeStamp.json';
        final todoFileName = 'todo_$timeStamp.json';

        final fileTask = File('$dlPath/$taskFileName');
        final fileTodo = File('$dlPath/$todoFileName');

        final task = await isar.tasks.where().exportJson();
        final todo = await isar.todos.where().exportJson();

        await fileTask.writeAsString(jsonEncode(task));
        await fileTodo.writeAsString(jsonEncode(todo));
        EasyLoading.showSuccess('successBackup'.tr);
      } catch (e) {
        EasyLoading.showError('error'.tr);
        return Future.error(e);
      }
    }
  }

  void restore() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      allowMultiple: true,
    );
    if (result == null) {
      EasyLoading.showInfo('errorPathRe'.tr);
      return;
    }

    for (final files in result.files) {
      final name = files.name.substring(0, 4);
      final file = File(files.path!);
      final jsonString = await file.readAsString();
      final dataList = jsonDecode(jsonString);

      for (final data in dataList) {
        await isar.writeTxn(() async {
          if (name == 'task') {
            try {
              final task = Tasks.fromJson(data);
              await isar.tasks.put(task);
              EasyLoading.showSuccess('successRestoreTask'.tr);
            } catch (e) {
              EasyLoading.showError('error'.tr);
              return Future.error(e);
            }
          } else if (name == 'todo') {
            try {
              final taskCollection = isar.tasks;
              final searchTask = await taskCollection
                  .filter()
                  .titleEqualTo('titleRe'.tr)
                  .findAll();
              final task = searchTask.isNotEmpty
                  ? searchTask.first
                  : Tasks(
                      title: 'titleRe'.tr,
                      description: 'descriptionRe'.tr,
                      taskColor: 4284513675,
                    );
              await isar.tasks.put(task);
              final todo = Todos.fromJson(data)..task.value = task;
              await isar.todos.put(todo);
              await todo.task.save();
              EasyLoading.showSuccess('successRestoreTodo'.tr);
            } catch (e) {
              EasyLoading.showError('error'.tr);
              return Future.error(e);
            }
          } else {
            EasyLoading.showInfo('errorFile'.tr);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingCard(
            icon: const Icon(Iconsax.cloud_plus),
            text: 'backup'.tr,
            onPressed: () async {
              check(backup);
            },
          ),
          SettingCard(
            icon: const Icon(Iconsax.cloud_add),
            text: 'restore'.tr,
            onPressed: () async {
              check(restore);
            },
          ),
          SettingCard(
            icon: const Icon(Iconsax.cloud_minus),
            text: 'deleteAllBD'.tr,
            onPressed: () => Get.dialog(
              AlertDialog(
                title: Text(
                  "deleteAllBDTitle".tr,
                  style: context.theme.textTheme.titleLarge,
                ),
                content: Text(
                  "deleteAllBDQuery".tr,
                  style: context.theme.textTheme.titleMedium,
                ),
                actions: [
                  TextButton(
                      onPressed: () => Get.back(),
                      child: Text("cancel".tr,
                          style: context.theme.textTheme.titleMedium
                              ?.copyWith(color: Colors.blueAccent))),
                  TextButton(
                      onPressed: () async {
                        await isar.writeTxn(() async {
                          await isar.todos.clear();
                          await isar.tasks.clear();
                        });
                        EasyLoading.showSuccess('deleteAll'.tr);
                        Get.back();
                      },
                      child: Text("delete".tr,
                          style: context.theme.textTheme.titleMedium
                              ?.copyWith(color: Colors.red))),
                ],
              ),
            ),
          ),
          SettingCard(
            icon: const Icon(Iconsax.code_circle),
            text: 'version'.tr,
            info: true,
            textInfo: '$appVersion',
          ),
          SettingCard(
            icon: Image.asset(
              'assets/images/github.png',
              scale: 20,
            ),
            text: '${'project'.tr} GitHub',
            onPressed: () async {
              final Uri url =
                  Uri.parse('https://github.com/DarkMooNight/ToDark');
              if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                throw Exception('Could not launch $url');
              }
            },
          ),
        ],
      ),
    );
  }
}
