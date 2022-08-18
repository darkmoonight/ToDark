import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:dark_todo/app/modules/home/controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DoingList extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  DoingList({Key? key}) : super(key: key);

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
                                } else if (direction ==
                                    DismissDirection.endToStart) {
                                  homeCtrl.doneTodo(
                                      element['title'], element['date']);
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
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                  ),
                                  child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            child: Icon(
                                              Icons.trip_origin,
                                              color: Colors.blue,
                                              size: theme.iconTheme.size,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15.w),
                                              child: Text(
                                                element['title'],
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                    theme.textTheme.headline6,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            element['date'],
                                            overflow: TextOverflow.ellipsis,
                                            style: theme
                                                .primaryTextTheme.subtitle2,
                                          ),
                                        ],
                                      )))));
                    }).toList(),
                    if (homeCtrl.doingTodos.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Divider(
                          // thickness: 1,
                          color: theme.dividerColor,
                        ),
                      )
                  ],
                ),
              ],
            ),
    );
  }
}
