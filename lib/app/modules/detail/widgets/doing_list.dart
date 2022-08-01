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
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 10.w),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/AddTasks.png',
                    fit: BoxFit.cover,
                    width: 65.w,
                  ),
                  Text(
                    'Add Task',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                      color: Colors.white,
                    ),
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
                    vertical: 2.w,
                    horizontal: 5.w,
                  ),
                  child: Text(
                    'Tasks(${homeCtrl.doingTodos.length})',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  ),
                ),
                Column(
                  children: [
                    ...homeCtrl.doingTodos.map((element) {
                      return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 2.w,
                            horizontal: 5.w,
                          ),
                          child: Dismissible(
                              key: ObjectKey(element),
                              direction: DismissDirection.startToEnd,
                              onDismissed: (_) =>
                                  homeCtrl.deleteDoingTodo(element),
                              background: Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                alignment: Alignment.centerLeft,
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
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: Checkbox(
                                                fillColor: MaterialStateProperty
                                                    .resolveWith((states) =>
                                                        Colors.grey),
                                                value: element['done'],
                                                onChanged: (value) {
                                                  homeCtrl.doneTodo(
                                                      element['title']);
                                                }),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 4.w),
                                            child: Text(
                                              element['title'],
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.sp,
                                              ),
                                            ),
                                          )
                                        ],
                                      )))));
                    }).toList(),
                    if (homeCtrl.doingTodos.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: const Divider(
                          // thickness: 1,
                          color: Colors.white,
                        ),
                      )
                  ],
                ),
              ],
            ),
    );
  }
}
