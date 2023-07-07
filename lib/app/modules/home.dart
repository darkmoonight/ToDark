import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:todark/app/modules/all_tasks.dart';
import 'package:todark/app/modules/calendar.dart';
import 'package:todark/app/modules/category.dart';
import 'package:todark/app/modules/settings.dart';
import 'package:todark/app/services/isar_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:todark/app/widgets/task_type_cu.dart';
import 'package:todark/app/widgets/todos_ce.dart';
import 'package:todark/theme/theme_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final service = IsarServices();
  final themeController = Get.put(ThemeController());
  int tabIndex = 0;

  final pages = const [
    CategoryPage(),
    AllTaskPage(),
    CalendarPage(),
    SettingsPage(),
  ];

  void changeTabIndex(int index) {
    setState(() {
      tabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: context.theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 30,
        title: Row(
          children: [
            Image.asset(
              'assets/icons/splash.png',
              scale: 15,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'ToDark',
              style: context.theme.textTheme.titleLarge,
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
              color: context.theme.iconTheme.color,
              size: 18,
            ),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            alignment: Alignment.centerLeft,
          ),
        ],
      ),
      body: IndexedStack(
        index: tabIndex,
        children: pages,
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
      floatingActionButton: tabIndex == 3
          ? null
          : FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  enableDrag: false,
                  backgroundColor: context.theme.colorScheme.surface,
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return tabIndex == 0
                        ? TaskTypeCu(
                            text: 'create'.tr,
                            edit: false,
                          )
                        : TodosCe(
                            text: "create".tr,
                            edit: false,
                            category: true,
                          );
                  },
                );
              },
              backgroundColor: context.theme.colorScheme.primaryContainer,
              child: const Icon(
                Iconsax.add,
                color: Colors.greenAccent,
              ),
            ),
    );
  }
}
