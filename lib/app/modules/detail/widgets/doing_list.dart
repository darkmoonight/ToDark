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
import '../../../core/values/colors.dart';

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
                              homeCtrl.doneTodo(
                                element['id'],
                                element['title'],
                                element['desc'],
                                element['date'],
                              );
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
                            width: MediaQuery.of(context).size.width,
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
                                    element['desc'],
                                    element['date'],
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      element['title'],
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.headline6,
                                    ),
                                    element['desc'].toString().isEmpty
                                        ? const SizedBox.shrink()
                                        : Flexible(
                                            child: SizedBox(height: 10.w)),
                                    element['desc'].toString().isEmpty
                                        ? const SizedBox.shrink()
                                        : Text(
                                            element['desc'],
                                            overflow: TextOverflow.ellipsis,
                                            style: theme
                                                .primaryTextTheme.subtitle2,
                                          ),
                                    element['date'].toString().isEmpty
                                        ? const SizedBox.shrink()
                                        : Flexible(
                                            child: SizedBox(height: 10.w)),
                                    element['date'].toString().isEmpty
                                        ? const SizedBox.shrink()
                                        : Text(
                                            element['date'],
                                            overflow: TextOverflow.ellipsis,
                                            style: theme
                                                .primaryTextTheme.subtitle2,
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
                          color: theme.dividerColor,
                        ),
                      ),
                  ],
                ),
              ],
            ),
    );
  }

  void showDialod(
      BuildContext context, int id, String title, String desc, String date) {
    final editText = TextEditingController(text: title);
    final editDesc = TextEditingController(text: desc);
    final editDate = TextEditingController(text: date);
    var theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => Scaffold(
        body: SafeArea(
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
                      },
                      icon: const Icon(Icons.close),
                      color: theme.iconTheme.color,
                      iconSize: theme.iconTheme.size,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.editTask,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 15.w, right: 15.w, bottom: 10.w, top: 5.w),
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
                padding: EdgeInsets.only(
                    left: 15.w, right: 15.w, bottom: 10.w, top: 5.w),
                child: TextFormField(
                  maxLines: 8,
                  minLines: 1,
                  style: Theme.of(context).textTheme.headline6,
                  controller: editDesc,
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
                    hintText: AppLocalizations.of(context)!.taskDesc,
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 15.sp,
                    ),
                  ),
                  autofocus: false,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 15.w, right: 15.w, bottom: 10.w, top: 5.w),
                child: TextField(
                  readOnly: true,
                  style: Theme.of(context).textTheme.headline6,
                  controller: editDate,
                  onTap: () {
                    DatePicker.showDateTimePicker(
                      context,
                      showTitleActions: true,
                      theme: DatePickerTheme(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        cancelStyle: const TextStyle(color: Colors.red),
                        itemStyle: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline6?.color),
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
                  autofocus: false,
                ),
              ),
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
              if (homeCtrl.formKeyDialog.currentState!.validate()) {
                homeCtrl.updateDoingTodo(
                  id,
                  title,
                  desc,
                  date,
                  editText.text,
                  editDesc.text,
                  editDate.text,
                );
                flutterLocalNotificationsPlugin.cancel(id);
                showNotification(id, editText.text, editDate.text);
                Get.back();
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
