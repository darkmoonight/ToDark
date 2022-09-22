import 'package:dark_todo/app/core/utils/extensions.dart';
import 'package:dark_todo/app/modules/detail/widgets/doing_list.dart';
import 'package:dark_todo/app/modules/detail/widgets/done_list.dart';
import 'package:dark_todo/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// ignore: unused_import, depend_on_referenced_packages
import 'package:timezone/data/latest_all.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;
import '../../../main.dart';
import '../../core/values/colors.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final homeCtrl = Get.find<HomeController>();
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var task = homeCtrl.task.value!;
    var color = HexColor.fromHex(task.color);
    return WillPopScope(
      onWillPop: () async {
        homeCtrl.updateTodos();
        homeCtrl.changeTask(null);
        homeCtrl.editCtrl.clear();
        homeCtrl.dateCtrl.clear();
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                        homeCtrl.updateTodos();
                        homeCtrl.changeTask(null);
                        homeCtrl.editCtrl.clear();
                        homeCtrl.dateCtrl.clear();
                      },
                      icon: const Icon(Icons.arrow_back),
                      color: theme.iconTheme.color,
                      iconSize: theme.iconTheme.size,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.w, right: 7.w),
                      child: Icon(
                        IconData(task.icon, fontFamily: 'MaterialIcons'),
                        color: color,
                        size: 22.sp,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        task.title,
                        style: theme.textTheme.headline2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() {
                var totalTodos =
                    homeCtrl.doingTodos.length + homeCtrl.doneTodos.length;
                return Padding(
                  padding: EdgeInsets.only(
                    left: 16.w,
                    top: 5.w,
                    right: 16.w,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '$totalTodos ${AppLocalizations.of(context)!.task(totalTodos)}',
                        style: theme.primaryTextTheme.subtitle2,
                      ),
                      SizedBox(
                        width: 13.w,
                      ),
                      Expanded(
                        child: StepProgressIndicator(
                          totalSteps: totalTodos == 0 ? 1 : totalTodos,
                          currentStep: homeCtrl.doneTodos.length,
                          size: 4.w,
                          padding: 0,
                          roundedEdges: const Radius.circular(10),
                          selectedGradientColor: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [color.withOpacity(0.5), color],
                          ),
                          unselectedColor: theme.unselectedWidgetColor,
                        ),
                      )
                    ],
                  ),
                );
              }),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
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
                  autofocus: false,
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
                  decoration: InputDecoration(
                    fillColor: theme.primaryColor,
                    filled: true,
                    prefixIcon: InkWell(
                      onTap: () {
                        DatePicker.showDateTimePicker(
                          context,
                          showTitleActions: true,
                          theme: DatePickerTheme(
                            backgroundColor: theme.scaffoldBackgroundColor,
                            cancelStyle: const TextStyle(color: Colors.red),
                            itemStyle: TextStyle(
                                color: theme.textTheme.headline6?.color),
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
                      child: const Icon(
                        Icons.calendar_month_outlined,
                      ),
                    ),
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
                  autofocus: false,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Divider(
                  color: theme.dividerColor,
                ),
              ),
              const DoingList(),
              const DoneList(),
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
                var success = homeCtrl.addTodo(
                    id, homeCtrl.editCtrl.text, homeCtrl.dateCtrl.text);
                if (success) {
                  EasyLoading.showSuccess(
                      AppLocalizations.of(context)!.todoAdd);
                  showNotification(
                      id, homeCtrl.editCtrl.text, homeCtrl.dateCtrl.text);
                  homeCtrl.updateTodos();
                } else {
                  EasyLoading.showError(
                      AppLocalizations.of(context)!.todoExist);
                }
                homeCtrl.editCtrl.clear();
                homeCtrl.dateCtrl.clear();
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
