import 'package:dark_todo/app/core/utils/extensions.dart';
import 'package:dark_todo/app/modules/detail/widgets/doing_list.dart';
import 'package:dark_todo/app/modules/detail/widgets/done_list.dart';
import 'package:dark_todo/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
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
                      onTap: () async {
                        pickDateTime();
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
              DoneList(),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.all(8.w),
          child: FloatingActionButton(
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
              Icons.save,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Future pickDateTime() async {
    DateTime? date = await pickDate();
    if (date == null) return;

    TimeOfDay? time = await pickTime();
    if (time == null) return;
    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() {
      this.dateTime = dateTime;
    });
    homeCtrl.dateCtrl.text =
        '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future showNotification(int id, String title, String date) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('13', 'ToDark',
            importance: Importance.max, priority: Priority.high);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    var scheduledTime = tz.TZDateTime.parse(tz.local, date);
    flutterLocalNotificationsPlugin.zonedSchedule(id, title,
        'Task completion time', scheduledTime, platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100));
  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));
}
