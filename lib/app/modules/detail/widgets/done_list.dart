import 'package:dark_todo/app/core/values/colors.dart';
import 'package:dark_todo/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DoneList extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  DoneList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Obx(() => homeCtrl.doneTodos.isNotEmpty
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
                  '${AppLocalizations.of(context)!.complet}(${homeCtrl.doneTodos.length})',
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
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) =>
                                homeCtrl.deleteDoneTodo(element),
                            background: Container(
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                ),
                                child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.w),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          child: Icon(
                                            Icons.done,
                                            color: blue,
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
                                              style: theme
                                                  .primaryTextTheme.headline6,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          element['date'],
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                              theme.primaryTextTheme.subtitle2,
                                        ),
                                      ],
                                    )))));
                  }).toList()
                ],
              )
            ],
          )
        : Container());
  }
}
