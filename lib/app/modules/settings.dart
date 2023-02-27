import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:todark/app/data/schema.dart';
import 'package:todark/app/modules/about.dart';
import 'package:todark/app/widgets/settings_link.dart';
import 'package:todark/main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void openPermission() async {}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.secondaryContainer,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 30, top: 17, bottom: 10, right: 20),
            child: Text(
              'settings'.tr,
              style: context.theme.textTheme.titleLarge?.copyWith(
                color: Get.isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SettingLinks(
            icon: Icon(
              Iconsax.cloud_plus,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
            text: 'backup'.tr,
            onPressed: () async {
              try {
                final timeStamp =
                    DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
                final dlPath = await FilePicker.platform.getDirectoryPath();
                final dbFileName = 'db_$timeStamp.isar';
                final dbFilePath = '$dlPath/$dbFileName';

                await isar.copyToFile(dbFilePath);
              } catch (e) {
                return Future.error(e);
              }
            },
          ),
          SettingLinks(
            icon: Icon(
              Iconsax.cloud_add,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
            text: 'restore'.tr,
            onPressed: () async {
              try {
                final dlPath = await FilePicker.platform.pickFiles();

                // FileMetadata? result = await PickOrSave().fileMetaData(
                //   params: FileMetadataParams(filePath: dlFile!.single),
                // );

                // final filePath = await LecleFlutterAbsolutePath.getAbsolutePath(
                //     uri: dlFile.single);

                if (isar.isOpen) {
                  await isar.close();
                }

                isar = await Isar.open(
                  [
                    TasksSchema,
                    TodosSchema,
                    SettingsSchema,
                  ],
                  name: dlPath!.files.single.name,
                  inspector: true,
                  directory: File(dlPath.files.single.path!).parent.path,
                );
              } catch (e) {
                return Future.error(e);
              }
            },
          ),
          SettingLinks(
            icon: Icon(
              Iconsax.cloud_minus,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
            text: 'deleteAllBD'.tr,
            onPressed: () => Get.dialog(
              AlertDialog(
                backgroundColor: context.theme.colorScheme.primaryContainer,
                title: Text(
                  "deleteAllBDTitle".tr,
                  style: context.theme.textTheme.titleLarge,
                ),
                content: Text("deleteAllBDQuery".tr,
                    style: context.theme.textTheme.titleMedium),
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
                        Get.back();
                      },
                      child: Text("delete".tr,
                          style: context.theme.textTheme.titleMedium
                              ?.copyWith(color: Colors.red))),
                ],
              ),
            ),
          ),
          SettingLinks(
            icon: Icon(
              Iconsax.info_circle,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
            text: 'about'.tr,
            onPressed: () => Get.to(
              () => const AboutPage(),
              transition: Transition.downToUp,
            ),
          ),
        ],
      ),
    );
  }
}
