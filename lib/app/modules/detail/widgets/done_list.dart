import 'package:dark_todo/app/core/values/colors.dart';
import 'package:dark_todo/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';

class DoneList extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  DoneList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => homeCtrl.doneTodos.isNotEmpty
        ? ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 2.w,
                  horizontal: 5.w,
                ),
                child: Text(
                  'Completed(${homeCtrl.doingTodos.length})',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                ),
              ),
              ...homeCtrl.doneTodos
                  .map((element) => Dismissible(
                      key: ObjectKey(element),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => homeCtrl.deleteDoneTodo(element),
                      background: Container(
                        color: Colors.red.withOpacity(0.8),
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: 5.w,
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 3.w,
                            horizontal: 9.w,
                          ),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: Icon(
                                  Icons.done,
                                  color: blue,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                ),
                                child: Text(
                                  element['title'],
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ),
                            ],
                          ))))
                  .toList()
            ],
          )
        : Container());
  }
}
