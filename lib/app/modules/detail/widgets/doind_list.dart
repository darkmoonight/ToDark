import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dark_todo/app/modules/home/controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DoingList extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  DoingList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => homeCtrl.doingTodos.isEmpty && homeCtrl.doneTodos.isEmpty
          ? Column(
              children: [
                Image.asset(
                  'assets/images/pngwing.png',
                  fit: BoxFit.cover,
                  width: 65.w,
                ),
                Text(
                  'Add Task',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                )
              ],
            )
          : ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                ...homeCtrl.doingTodos
                    .map((element) => Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 3.w,
                          horizontal: 9.w,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                  fillColor: MaterialStateProperty.resolveWith(
                                      (states) => Colors.grey),
                                  value: element['done'],
                                  onChanged: (value) {
                                    homeCtrl.doneTodo(element['title']);
                                  }),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: Text(
                                element['title'],
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        )))
                    .toList(),
                if (homeCtrl.doingTodos.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: const Divider(
                      thickness: 2,
                    ),
                  )
              ],
            ),
    );
  }
}
