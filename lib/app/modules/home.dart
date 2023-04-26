import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:todark/app/modules/all_tasks.dart';
import 'package:todark/app/modules/calendar.dart';
import 'package:todark/app/modules/category.dart';
import 'package:todark/app/modules/settings.dart';
import 'package:todark/app/services/isar_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:todark/theme/theme_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final service = IsarServices();
  final themeController = Get.put(ThemeController());
  final _bucket = PageStorageBucket();
  int tabIndex = 0;

  var widgetList = const [
    CategoryPage(key: PageStorageKey(1)),
    AllTaskPage(key: PageStorageKey(2)),
    CalendarPage(key: PageStorageKey(3)),
    SettingsPage(key: PageStorageKey(4)),
  ];

  void changeTabIndex(int index) {
    setState(() {
      tabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: context.theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 30,
        title: Row(
          children: [
            Image.asset(
              'assets/icons/icon_splash.png',
              scale: 15,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'ToDark',
              style: context.theme.primaryTextTheme.titleLarge,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (Get.isDarkMode) {
                themeController.changeThemeMode(ThemeMode.light);
                themeController.saveTheme(false);
              } else {
                themeController.changeThemeMode(ThemeMode.dark);
                themeController.saveTheme(true);
              }
            },
            icon: Icon(
              Get.isDarkMode ? Iconsax.sun_1 : Iconsax.moon,
              color: Colors.white,
              size: 18,
            ),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            alignment: Alignment.centerLeft,
          ),
        ],
      ),
      body: PageStorage(
        bucket: _bucket,
        child: widgetList[tabIndex],
      ),
      bottomNavigationBar: Theme(
        data: context.theme.copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: CustomNavigationBar(
          backgroundColor: context.theme.colorScheme.secondaryContainer,
          strokeColor: const Color(0x300c18fb),
          onTap: (int index) => changeTabIndex(index),
          currentIndex: tabIndex,
          iconSize: 24,
          elevation: 0,
          items: [
            CustomNavigationBarItem(icon: const Icon(Iconsax.folder_2)),
            CustomNavigationBarItem(icon: const Icon(Iconsax.task_square)),
            CustomNavigationBarItem(icon: const Icon(Iconsax.calendar_1)),
            CustomNavigationBarItem(icon: const Icon(Iconsax.setting_2)),
          ],
        ),
      ),
    );
  }
}
