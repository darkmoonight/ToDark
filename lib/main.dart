import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:todark/app/modules/home.dart';
import 'package:todark/app/modules/onboarding_screen.dart';
import 'package:todark/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:isar/isar.dart';
import 'package:todark/theme/theme_controller.dart';
import 'app/data/schema.dart';
import 'package:path_provider/path_provider.dart';
import 'translation/translation.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

late Isar isar;
late Settings settings;
String? appVersion;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setOptimalDisplayMode();
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(systemNavigationBarColor: Colors.black));
  infoVersion();
  await isarInit();
  runApp(MyApp());
}

Future<void> setOptimalDisplayMode() async {
  final List<DisplayMode> supported = await FlutterDisplayMode.supported;
  final DisplayMode active = await FlutterDisplayMode.active;

  final List<DisplayMode> sameResolution = supported
      .where((DisplayMode m) =>
          m.width == active.width && m.height == active.height)
      .toList()
    ..sort((DisplayMode a, DisplayMode b) =>
        b.refreshRate.compareTo(a.refreshRate));

  final DisplayMode mostOptimalMode =
      sameResolution.isNotEmpty ? sameResolution.first : active;

  await FlutterDisplayMode.setPreferredMode(mostOptimalMode);
}

Future<void> infoVersion() async {
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  appVersion = packageInfo.version;
}

Future<void> isarInit() async {
  isar = await Isar.open(
    [
      TasksSchema,
      TodosSchema,
      SettingsSchema,
    ],
    directory: (await getApplicationSupportDirectory()).path,
  );
  settings = await isar.settings.where().findFirst() ?? Settings();
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        return GetMaterialApp(
          theme: TodoTheme.lightTheme,
          darkTheme: TodoTheme.darkTheme,
          themeMode: themeController.theme,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          translations: Translation(),
          locale: Get.deviceLocale,
          fallbackLocale: const Locale('en', 'US'),
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ru', 'RU'),
            Locale('zh', 'CN'),
            Locale('zh', 'TW'),
            Locale('fa', 'IR'),
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          debugShowCheckedModeBanner: false,
          home: settings.onboard == false
              ? const OnBordingScreen()
              : const HomePage(),
          builder: EasyLoading.init(),
        );
      },
    );
  }
}
