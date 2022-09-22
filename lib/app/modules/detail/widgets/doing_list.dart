import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:dark_todo/app/modules/home/controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// ignore: unused_import, depend_on_referenced_packages
import 'package:timezone/data/latest_all.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;
import '../../../../main.dart';

class DoingList extends StatefulWidget {
  const DoingList({Key? key}) : super(key: key);

  @override
  State<DoingList> createState() => _DoingListState();
}

class _DoingListState extends State<DoingList> {
  final homeCtrl = Get.find<HomeController>();
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Obx(
      () => homeCtrl.doingTodos.isEmpty && homeCtrl.doneTodos.isEmpty
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 30.w),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/AddTasks.png',
                    fit: BoxFit.cover,
                    width: 255.w,
                  ),
                  Text(
                    AppLocalizations.of(context)!.addTask,
                    style: theme.textTheme.headline4,
                  )
                ],
              ),
            )
          : ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 5.w,
                    horizontal: 15.w,
                  ),
                  child: Text(
                    '${AppLocalizations.of(context)!.tasks} (${homeCtrl.doingTodos.length})',
                    style: theme.primaryTextTheme.subtitle1,
                  ),
                ),
                Column(
                  children: [
                    ...homeCtrl.doingTodos.map((element) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: 5.w, left: 15.w, right: 15.w, bottom: 10.w),
                        child: Dismissible(
                          key: ObjectKey(element),
                          onDismissed: (DismissDirection direction) {
                            if (direction == DismissDirection.startToEnd) {
                              homeCtrl.deleteDoingTodo(element);
                              flutterLocalNotificationsPlugin
                                  .cancel(element['id']);
                              homeCtrl.updateTodos();
                            } else if (direction ==
                                DismissDirection.endToStart) {
                              homeCtrl.doneTodo(element['id'], element['title'],
                                  element['date']);
                              flutterLocalNotificationsPlugin
                                  .cancel(element['id']);
                              homeCtrl.updateTodos();
                            }
                          },
                          background: Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: 15.w,
                              ),
                              child: Icon(
                                Icons.delete,
                                color: theme.iconTheme.color,
                                size: theme.iconTheme.size,
                              ),
                            ),
                          ),
                          secondaryBackground: Container(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: 15.w,
                              ),
                              child: Icon(
                                Icons.done,
                                color: theme.iconTheme.color,
                                size: theme.iconTheme.size,
                              ),
                            ),
                          ),
                          child: Container(
                            height: 55.w,
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 5.w, right: 5.w),
                              child: CupertinoButton(
                                onPressed: () {
                                  showDialod(
                                    context,
                                    element['id'],
                                    element['title'],
                                    element['date'],
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        element['title'],
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.headline6,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Text(
                                      element['date'],
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.primaryTextTheme.subtitle2,
                                      textAlign: TextAlign.end,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    if (homeCtrl.doingTodos.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Divider(
                          // thickness: 1,
                          color: theme.dividerColor,
                        ),
                      ),
                  ],
                ),
              ],
            ),
    );
  }

  void showDialod(BuildContext context, int id, String title, String date) {
    final editText = TextEditingController(text: title);
    final editDate = TextEditingController(text: date);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.w))),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          AppLocalizations.of(context)!.editTask,
          style: Theme.of(context).textTheme.headline4,
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 15.w),
              child: TextFormField(
                key: homeCtrl.formKeyDialog,
                style: Theme.of(context).textTheme.headline6,
                controller: editText,
                decoration: InputDecoration(
                  fillColor: Theme.of(context).primaryColor,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
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
            TextField(
              readOnly: true,
              style: Theme.of(context).textTheme.headline6,
              controller: editDate,
              onTap: () {
                DatePicker.showDateTimePicker(
                  context,
                  showTitleActions: true,
                  theme: DatePickerTheme(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    cancelStyle: const TextStyle(color: Colors.red),
                    itemStyle: TextStyle(
                        color: Theme.of(context).textTheme.headline6?.color),
                  ),
                  minTime: DateTime(2022, 09, 01),
                  maxTime: DateTime(2100, 09, 01),
                  onConfirm: (date) {
                    editDate.text =
                        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
                  },
                  currentTime: DateTime.now(),
                  locale: getLocale(),
                );
              },
              decoration: InputDecoration(
                fillColor: Theme.of(context).primaryColor,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
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
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
          TextButton(
            onPressed: () {
              if (homeCtrl.formKeyDialog.currentState!.validate()) {
                homeCtrl.updateDoingTodo(
                    id, title, date, editText.text, editDate.text);
                flutterLocalNotificationsPlugin.cancel(id);
                showNotification(id, editText.text, editDate.text);
                Navigator.pop(context, 'Ok');
              }
            },
            child: Text(
              'OK',
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
        ],
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
