import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:dark_todo/app/data/services/storage/services.dart';
import 'package:dark_todo/app/modules/home/binding.dart';
import 'package:dark_todo/app/modules/home/view.dart';
import 'package:dark_todo/app/screens/onboarding_screen.dart';
import 'package:dark_todo/utils/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

int? isviewed;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('OnboardingScreen');
  await GetStorage.init();
  await Get.putAsync(() => StorageService().init());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ThemeProvider(
          initTheme: themeController.themes,
          builder: (_, theme) {
            return GetMaterialApp(
              themeMode: themeController.theme,
              theme: theme,
              localeResolutionCallback: (
                locale,
                supportedLocales,
              ) {
                return const Locale('en', '');
              },
              localizationsDelegates: const [
                AppLocalizations.delegate, // Add this line
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', ''),
              ],
              debugShowCheckedModeBanner: false,
              home: isviewed != 0 ? const OnboardingScreen() : HomePage(),
              initialBinding: HomeBinding(),
              builder: EasyLoading.init(),
            );
          },
        );
      },
    );
  }
}
