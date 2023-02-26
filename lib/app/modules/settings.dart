import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:permission_handler/permission_handler.dart';
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
  void openPermission() async {
    final theme = context.theme;
    Get.snackbar(
      '',
      '',
      backgroundColor: theme.snackBarTheme.backgroundColor,
      mainButton: TextButton(
        onPressed: () => openAppSettings(),
        child: Text(
          'sett',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.blue),
        ),
      ),
      icon: const Icon(Iconsax.folder_minus),
      shouldIconPulse: true,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
    );
  }

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
              'Настройки',
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
            text: 'Резервное копирование',
            onPressed: () async {
              try {
                openPermission();

                final timeStamp =
                    DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
                final dlPath = await FilePicker.platform.getDirectoryPath();
                final dbFileName = 'db_$timeStamp.isar';
                final dbFilePath = '$dlPath/$dbFileName';
                final dbFile = File(dbFilePath);

                final exists = await dbFile.exists();

                if (exists) {
                  await dbFile.delete(recursive: true);
                }

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
            text: 'Загрузка данных',
            onPressed: () async {
              try {
                final dlPath = await FilePicker.platform.getDirectoryPath();
                final dbFilePath = '$dlPath/';

                if (isar.isOpen) {
                  await isar.close();
                }
                await Isar.open(
                  [
                    TasksSchema,
                    TodosSchema,
                    SettingsSchema,
                  ],
                  directory: dbFilePath,
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
            text: 'Удалить все данные',
            onPressed: () => Get.dialog(
              AlertDialog(
                backgroundColor: context.theme.colorScheme.primaryContainer,
                title: Text(
                  "Удаление данных",
                  style: context.theme.textTheme.titleLarge,
                ),
                content: Text("Вы уверены что хотите удалить все данные?",
                    style: context.theme.textTheme.titleMedium),
                actions: [
                  TextButton(
                      onPressed: () => Get.back(),
                      child: Text("Закрыть",
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
                      child: Text("Удалить",
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
            text: 'О нас',
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

class Log {}
