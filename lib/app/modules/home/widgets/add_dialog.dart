// ignore_for_file: depend_on_referenced_packages
import 'package:dark_todo/app/core/utils/extensions.dart';
import 'package:dark_todo/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// ignore: unused_import
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../../../main.dart';
import '../../../core/values/colors.dart';

class AddDialog extends StatefulWidget {
  const AddDialog({Key? key}) : super(key: key);

  @override
  State<AddDialog> createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  final homeCtrl = Get.find<HomeController>();
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        homeCtrl.editCtrl.clear();
        homeCtrl.dateCtrl.clear();
        homeCtrl.changeTask(null);
        return true;
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Form(
          key: homeCtrl.formKey,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(10.w),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                        homeCtrl.editCtrl.clear();
                        homeCtrl.dateCtrl.clear();
                        homeCtrl.changeTask(null);
                      },
                      icon: const Icon(Icons.close),
                      iconSize: theme.iconTheme.size,
                      color: theme.iconTheme.color,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(
                        AppLocalizations.of(context)!.createTask,
                        style: theme.textTheme.headline2,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 15.w, right: 15.w, bottom: 15.w, top: 5.w),
                child: TextFormField(
                  style: theme.textTheme.headline6,
                  controller: homeCtrl.editCtrl,
                  decoration: InputDecoration(
                    fillColor: theme.primaryColor,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: theme.primaryColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: theme.primaryColor,
                      ),
                    ),
                    hintText: AppLocalizations.of(context)!.taskName,
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 15.sp,
                    ),
                  ),
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLocalizations.of(context)!.showEnter;
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.w, left: 15.w, bottom: 15.w),
                child: TextField(
                  readOnly: true,
                  style: theme.textTheme.headline6,
                  controller: homeCtrl.dateCtrl,
                  onTap: () {
                    DatePicker.showDateTimePicker(
                      context,
                      showTitleActions: true,
                      theme: DatePickerTheme(
                        backgroundColor: theme.scaffoldBackgroundColor,
                        cancelStyle: const TextStyle(color: Colors.red),
                        itemStyle:
                            TextStyle(color: theme.textTheme.headline6?.color),
                      ),
                      minTime: DateTime(2022, 09, 01),
                      maxTime: DateTime(2100, 09, 01),
                      onConfirm: (date) {
                        homeCtrl.dateCtrl.text =
                            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
                      },
                      currentTime: DateTime.now(),
                      locale: getLocale(),
                    );
                  },
                  decoration: InputDecoration(
                    fillColor: theme.primaryColor,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: theme.primaryColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: theme.primaryColor,
                      ),
                    ),
                    hintText: AppLocalizations.of(context)!.taskDate,
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 15.sp,
                    ),
                  ),
                  autofocus: true,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 15.w, right: 15.w, bottom: 10.w, top: 5.w),
                child: Text(
                  AppLocalizations.of(context)!.add,
                  style: theme.textTheme.subtitle1,
                ),
              ),
              ...homeCtrl.tasks
                  .map(
                    (element) => Obx(
                      () => InkWell(
                        onTap: () => homeCtrl.changeTask(element),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.w,
                            horizontal: 15.w,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 7.w),
                                child: Icon(
                                  IconData(
                                    element.icon,
                                    fontFamily: 'MaterialIcons',
                                  ),
                                  color: HexColor.fromHex(element.color),
                                  size: 20.sp,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  element.title,
                                  style: theme.textTheme.headline6,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (homeCtrl.task.value == element)
                                const Icon(
                                  Icons.check,
                                  color: Colors.blue,
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList()
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.all(8.w),
          child: FloatingActionButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 0,
            onPressed: () {
              final id = homeCtrl.random.nextInt(1000000);
              if (homeCtrl.formKey.currentState!.validate()) {
                if (homeCtrl.task.value == null) {
                  EasyLoading.showError(
                      AppLocalizations.of(context)!.showSelect);
                } else {
                  var success = homeCtrl.updateTask(
                    homeCtrl.task.value!,
                    id,
                    homeCtrl.editCtrl.text,
                    homeCtrl.dateCtrl.text,
                  );
                  if (success) {
                    EasyLoading.showSuccess(
                        AppLocalizations.of(context)!.todoAdd);
                    showNotification(
                        id, homeCtrl.editCtrl.text, homeCtrl.dateCtrl.text);
                    Get.back();
                    homeCtrl.changeTask(null);
                  } else {
                    EasyLoading.showError(
                        AppLocalizations.of(context)!.todoExist);
                  }
                  homeCtrl.editCtrl.clear();
                  homeCtrl.dateCtrl.clear();
                }
              }
            },
            backgroundColor: blue,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Future showNotification(int id, String title, String date) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('13', 'ToDark',
            importance: Importance.max, priority: Priority.high);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    var scheduledTime = tz.TZDateTime.parse(tz.local, date);
    flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        AppLocalizations.of(context)!.taskTime,
        scheduledTime,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  getLocale() {
    Locale locale = Localizations.localeOf(context);
    final LocaleType myLocal;
    if (locale.toString() == "ru") {
      myLocal = LocaleType.ru;
    } else {
      myLocal = LocaleType.en;
    }
    return myLocal;
  }
}
