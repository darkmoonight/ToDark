import 'package:dark_todo/app/core/values/colors.dart';
import 'package:dark_todo/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                  vertical: 12.w,
                  horizontal: 15.w,
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
                          vertical: 12.w,
                          horizontal: 15.w,
                        ),
                        child: Dismissible(
                            key: ObjectKey(element),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) =>
                                homeCtrl.deleteDoneTodo(element),
                            background: Container(
                              height: 40.w,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: 15.w,
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            child: Container(
                                height: 60.w,
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
                                            horizontal: 14.w,
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
