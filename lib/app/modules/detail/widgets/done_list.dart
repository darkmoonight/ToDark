import 'package:dark_todo/app/modules/home/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// ignore: unused_import, depend_on_referenced_packages
import 'package:timezone/data/latest_all.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;
import '../../../../main.dart';

class DoneList extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  DoneList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Obx(
      () => homeCtrl.doneTodos.isNotEmpty
          ? ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 5.w,
                    horizontal: 15.w,
                  ),
                  child: Text(
                    '${AppLocalizations.of(context)!.complet} (${homeCtrl.doneTodos.length})',
                    style: theme.primaryTextTheme.subtitle1,
                  ),
                ),
                Column(
                  children: [
                    ...homeCtrl.doneTodos.map((element) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: 5.w, left: 15.w, right: 15.w, bottom: 10.w),
                        child: Dismissible(
                          key: ObjectKey(element),
                          onDismissed: (DismissDirection direction) {
                            if (direction == DismissDirection.endToStart) {
                              homeCtrl.deleteDoneTodo(element);
                              homeCtrl.updateTodos();
                            } else if (direction ==
                                DismissDirection.startToEnd) {
                              homeCtrl.doingTodo(element['id'],
                                  element['title'], element['date']);
                              showNotification(element['id'], element['title'],
                                  element['date']);
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
                                Icons.close,
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
                                Icons.delete,
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
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: CupertinoButton(
                                onPressed: null,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        element['title'],
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.primaryTextTheme.headline6,
                                      ),
                                    ),
                                    Text(
                                      element['date'],
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.primaryTextTheme.subtitle2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList()
                  ],
                ),
              ],
            )
          : Container(),
    );
  }
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
