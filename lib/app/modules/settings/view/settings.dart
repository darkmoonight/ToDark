import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:todark/app/controller/todo_controller.dart';
import 'package:todark/app/controller/isar_contoller.dart';
import 'package:todark/app/data/schema.dart';
import 'package:todark/app/modules/settings/widgets/settings_card.dart';
import 'package:todark/main.dart';
import 'package:todark/theme/theme_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final todoController = Get.put(TodoController());
  final isarController = Get.put(IsarController());
  final themeController = Get.put(ThemeController());
  String? appVersion;

  Future<void> infoVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  updateLanguage(Locale locale) {
    settings.language = '$locale';
    isar.writeTxnSync(() => isar.settings.putSync(settings));
    Get.updateLocale(locale);
    Get.back();
  }

  String firstDayOfWeek(newValue) {
    if (newValue == 'monday'.tr) {
      return 'monday';
    } else if (newValue == 'tuesday'.tr) {
      return 'tuesday';
    } else if (newValue == 'wednesday'.tr) {
      return 'wednesday';
    } else if (newValue == 'thursday'.tr) {
      return 'thursday';
    } else if (newValue == 'friday'.tr) {
      return 'friday';
    } else if (newValue == 'saturday'.tr) {
      return 'saturday';
    } else if (newValue == 'sunday'.tr) {
      return 'sunday';
    } else {
      return 'monday';
    }
  }

  @override
  void initState() {
    infoVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'settings'.tr,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SettingCard(
              icon: const Icon(Iconsax.brush_1),
              text: 'appearance'.tr,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, setState) {
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                child: Text(
                                  'appearance'.tr,
                                  style: context.textTheme.titleLarge?.copyWith(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              SettingCard(
                                elevation: 4,
                                icon: const Icon(Iconsax.moon),
                                text: 'theme'.tr,
                                dropdown: true,
                                dropdownName: settings.theme?.tr,
                                dropdownList: <String>[
                                  'system'.tr,
                                  'dark'.tr,
                                  'light'.tr
                                ],
                                dropdownCange: (String? newValue) {
                                  ThemeMode themeMode =
                                      newValue?.tr == 'system'.tr
                                          ? ThemeMode.system
                                          : newValue?.tr == 'dark'.tr
                                              ? ThemeMode.dark
                                              : ThemeMode.light;
                                  String theme = newValue?.tr == 'system'.tr
                                      ? 'system'
                                      : newValue?.tr == 'dark'.tr
                                          ? 'dark'
                                          : 'light';
                                  themeController.saveTheme(theme);
                                  themeController.changeThemeMode(themeMode);
                                  setState(() {});
                                },
                              ),
                              SettingCard(
                                elevation: 4,
                                icon: const Icon(Iconsax.mobile),
                                text: 'amoledTheme'.tr,
                                switcher: true,
                                value: settings.amoledTheme,
                                onChange: (value) {
                                  themeController.saveOledTheme(value);
                                  MyApp.updateAppState(context,
                                      newAmoledTheme: value);
                                },
                              ),
                              SettingCard(
                                elevation: 4,
                                icon: const Icon(Iconsax.colorfilter),
                                text: 'materialColor'.tr,
                                switcher: true,
                                value: settings.materialColor,
                                onChange: (value) {
                                  themeController.saveMaterialTheme(value);
                                  MyApp.updateAppState(context,
                                      newMaterialColor: value);
                                },
                              ),
                              SettingCard(
                                elevation: 4,
                                icon: const Icon(Iconsax.image),
                                text: 'isImages'.tr,
                                switcher: true,
                                value: settings.isImage,
                                onChange: (value) {
                                  isar.writeTxnSync(() {
                                    settings.isImage = value;
                                    isar.settings.putSync(settings);
                                  });
                                  MyApp.updateAppState(context,
                                      newIsImage: value);
                                },
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            SettingCard(
              icon: const Icon(Iconsax.code),
              text: 'functions'.tr,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, setState) {
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                child: Text(
                                  'functions'.tr,
                                  style: context.textTheme.titleLarge?.copyWith(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              SettingCard(
                                elevation: 4,
                                icon: const Icon(Iconsax.clock),
                                text: 'timeformat'.tr,
                                dropdown: true,
                                dropdownName: settings.timeformat.tr,
                                dropdownList: <String>['12'.tr, '24'.tr],
                                dropdownCange: (String? newValue) {
                                  isar.writeTxnSync(() {
                                    settings.timeformat =
                                        newValue == '12'.tr ? '12' : '24';
                                    isar.settings.putSync(settings);
                                  });
                                  MyApp.updateAppState(context,
                                      newTimeformat:
                                          newValue == '12'.tr ? '12' : '24');
                                  setState(() {});
                                },
                              ),
                              SettingCard(
                                elevation: 4,
                                icon: const Icon(Iconsax.calendar_edit),
                                text: 'firstDayOfWeek'.tr,
                                dropdown: true,
                                dropdownName: settings.firstDay.tr,
                                dropdownList: <String>[
                                  'monday'.tr,
                                  'tuesday'.tr,
                                  'wednesday'.tr,
                                  'thursday'.tr,
                                  'friday'.tr,
                                  'saturday'.tr,
                                  'sunday'.tr,
                                ],
                                dropdownCange: (String? newValue) {
                                  isar.writeTxnSync(() {
                                    if (newValue == 'monday'.tr) {
                                      settings.firstDay = 'monday';
                                    } else if (newValue == 'tuesday'.tr) {
                                      settings.firstDay = 'tuesday';
                                    } else if (newValue == 'wednesday'.tr) {
                                      settings.firstDay = 'wednesday';
                                    } else if (newValue == 'thursday'.tr) {
                                      settings.firstDay = 'thursday';
                                    } else if (newValue == 'friday'.tr) {
                                      settings.firstDay = 'friday';
                                    } else if (newValue == 'saturday'.tr) {
                                      settings.firstDay = 'saturday';
                                    } else if (newValue == 'sunday'.tr) {
                                      settings.firstDay = 'sunday';
                                    }
                                    isar.settings.putSync(settings);
                                  });
                                  MyApp.updateAppState(context,
                                      newTimeformat: firstDayOfWeek(newValue));
                                  setState(() {});
                                },
                              ),
                              SettingCard(
                                elevation: 4,
                                icon: const Icon(Iconsax.cloud_plus),
                                text: 'backup'.tr,
                                onPressed: isarController.createBackUp,
                              ),
                              SettingCard(
                                elevation: 4,
                                icon: const Icon(Iconsax.cloud_add),
                                text: 'restore'.tr,
                                onPressed: isarController.restoreDB,
                              ),
                              SettingCard(
                                elevation: 4,
                                icon: const Icon(Iconsax.cloud_minus),
                                text: 'deleteAllBD'.tr,
                                onPressed: () => showAdaptiveDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog.adaptive(
                                    title: Text(
                                      'deleteAllBDTitle'.tr,
                                      style: context.textTheme.titleLarge,
                                    ),
                                    content: Text(
                                      'deleteAllBDQuery'.tr,
                                      style: context.textTheme.titleMedium,
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () => Get.back(),
                                          child: Text('cancel'.tr,
                                              style: context
                                                  .theme.textTheme.titleMedium
                                                  ?.copyWith(
                                                      color:
                                                          Colors.blueAccent))),
                                      TextButton(
                                          onPressed: () {
                                            isar.writeTxnSync(() {
                                              isar.todos.clearSync();
                                              isar.tasks.clearSync();
                                              todoController.tasks.clear();
                                              todoController.todos.clear();
                                            });
                                            EasyLoading.showSuccess(
                                                'deleteAll'.tr);
                                            Get.back();
                                          },
                                          child: Text('delete'.tr,
                                              style: context
                                                  .theme.textTheme.titleMedium
                                                  ?.copyWith(
                                                      color: Colors.red))),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            SettingCard(
              icon: const Icon(Iconsax.language_square),
              text: 'language'.tr,
              info: true,
              infoSettings: true,
              textInfo: appLanguages.firstWhere(
                  (element) => (element['locale'] == locale),
                  orElse: () => appLanguages.first)['name'],
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, setState) {
                        return ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child: Text(
                                'language'.tr,
                                style: context.textTheme.titleLarge?.copyWith(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: appLanguages.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 4,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  child: ListTile(
                                    title: Text(
                                      appLanguages[index]['name'],
                                      style: context.textTheme.labelLarge,
                                      textAlign: TextAlign.center,
                                    ),
                                    onTap: () {
                                      MyApp.updateAppState(context,
                                          newLocale: appLanguages[index]
                                              ['locale']);
                                      updateLanguage(
                                          appLanguages[index]['locale']);
                                    },
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
            SettingCard(
              icon: const Icon(Iconsax.dollar_square),
              text: 'support'.tr,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, setState) {
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                child: Text(
                                  'support'.tr,
                                  style: context.textTheme.titleLarge?.copyWith(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              SettingCard(
                                elevation: 4,
                                icon: const Icon(Iconsax.card),
                                text: 'DonationAlerts',
                                onPressed: () async {
                                  final Uri url = Uri.parse(
                                      'https://www.donationalerts.com/r/darkmoonight');
                                  if (!await launchUrl(url,
                                      mode: LaunchMode.externalApplication)) {
                                    throw Exception('Could not launch $url');
                                  }
                                },
                              ),
                              SettingCard(
                                elevation: 4,
                                icon: const Icon(Iconsax.wallet),
                                text: 'ЮMoney',
                                onPressed: () async {
                                  final Uri url = Uri.parse(
                                      'https://yoomoney.ru/to/4100117672775961');
                                  if (!await launchUrl(url,
                                      mode: LaunchMode.externalApplication)) {
                                    throw Exception('Could not launch $url');
                                  }
                                },
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            SettingCard(
              icon: const Icon(Iconsax.link_square),
              text: 'groups'.tr,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, setState) {
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                child: Text(
                                  'groups'.tr,
                                  style: context.textTheme.titleLarge?.copyWith(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              SettingCard(
                                elevation: 4,
                                icon: const Icon(Iconsax.voice_square),
                                text: 'Discord',
                                onPressed: () async {
                                  final Uri url = Uri.parse(
                                      'https://discord.gg/JMMa9aHh8f');
                                  if (!await launchUrl(url,
                                      mode: LaunchMode.externalApplication)) {
                                    throw Exception('Could not launch $url');
                                  }
                                },
                              ),
                              SettingCard(
                                elevation: 4,
                                icon: const Icon(Iconsax.message_square),
                                text: 'Telegram',
                                onPressed: () async {
                                  final Uri url =
                                      Uri.parse('https://t.me/darkmoonightX');
                                  if (!await launchUrl(url,
                                      mode: LaunchMode.externalApplication)) {
                                    throw Exception('Could not launch $url');
                                  }
                                },
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            SettingCard(
              icon: const Icon(Iconsax.document),
              text: 'license'.tr,
              onPressed: () => Get.to(
                LicensePage(
                  applicationIcon: Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        image: DecorationImage(
                            image: AssetImage('assets/icons/icon.png'))),
                  ),
                  applicationName: 'ToDark',
                  applicationVersion: appVersion,
                ),
                transition: Transition.downToUp,
              ),
            ),
            SettingCard(
              icon: const Icon(Iconsax.hierarchy_square_2),
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
                if (!await launchUrl(url,
                    mode: LaunchMode.externalApplication)) {
                  throw Exception('Could not launch $url');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
