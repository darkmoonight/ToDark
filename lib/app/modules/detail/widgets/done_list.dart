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
                  'Completed(${homeCtrl.doneTodos.length})',
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                ),
              ),
              Column(
                children: [
                  ...homeCtrl.doneTodos.map((element) {
                    return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 2.w,
                          horizontal: 5.w,
                        ),
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
                                  right: 5.w,
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            child: Container(
                                height: 15.w,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 40, 40, 40),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.w),
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
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Colors.white,
                                              fontSize: 18.sp,
                                            ),
                                          ),
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
