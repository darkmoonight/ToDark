import 'package:dark_todo/app/core/utils/extensions.dart';
import 'package:dark_todo/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class AddDialog extends StatefulWidget {
  const AddDialog({Key? key}) : super(key: key);

  @override
  State<AddDialog> createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  final homeCtrl = Get.find<HomeController>();
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        homeCtrl.editCtrl.clear();
        homeCtrl.dateCtrl.clear();
        homeCtrl.changeTask(null);
        return true;
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Form(
          key: homeCtrl.formKey,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                        homeCtrl.editCtrl.clear();
                        homeCtrl.dateCtrl.clear();
                        homeCtrl.changeTask(null);
                      },
                      icon: const Icon(Icons.close),
                      iconSize: theme.iconTheme.size,
                      color: theme.iconTheme.color,
                    ),
                    TextButton(
                        style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent)),
                        onPressed: () {
                          if (homeCtrl.formKey.currentState!.validate()) {
                            if (homeCtrl.task.value == null) {
                              EasyLoading.showError(
                                  AppLocalizations.of(context)!.showSelect);
                            } else {
                              var success = homeCtrl.updateTask(
                                homeCtrl.task.value!,
                                homeCtrl.editCtrl.text,
                                homeCtrl.dateCtrl.text,
                              );
                              if (success) {
                                EasyLoading.showSuccess(
                                    AppLocalizations.of(context)!.todoAdd);
                                Get.back();
                                homeCtrl.changeTask(null);
                              } else {
                                EasyLoading.showError(
                                    AppLocalizations.of(context)!.todoExist);
                              }
                              homeCtrl.editCtrl.clear();
                              homeCtrl.dateCtrl.clear();
                            }
                          }
                        },
                        child: Text(
                          AppLocalizations.of(context)!.done,
                          style: TextStyle(
                            fontSize: 16.sp,
                          ),
                        ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Text(
                  AppLocalizations.of(context)!.createTask,
                  style: theme.textTheme.headline2,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
                child: TextFormField(
                  style: theme.textTheme.headline6,
                  controller: homeCtrl.editCtrl,
                  decoration: InputDecoration(
                    fillColor: theme.primaryColor,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: theme.primaryColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: theme.primaryColor,
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
              Padding(
                padding: EdgeInsets.only(right: 15.w, left: 15.w, bottom: 15.w),
                child: TextField(
                  readOnly: true,
                  style: theme.textTheme.headline6,
                  controller: homeCtrl.dateCtrl,
                  decoration: InputDecoration(
                    fillColor: theme.primaryColor,
                    filled: true,
                    prefixIcon: InkWell(
                      onTap: () async {
                        pickDateTime();
                      },
                      child: const Icon(
                        Icons.calendar_month_outlined,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: theme.primaryColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: theme.primaryColor,
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
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 15.w,
                  right: 15.w,
                  bottom: 5.w,
                ),
                child: Text(
                  AppLocalizations.of(context)!.add,
                  style: theme.textTheme.subtitle1,
                ),
              ),
              ...homeCtrl.tasks
                  .map((element) => Obx(() => InkWell(
                      onTap: () => homeCtrl.changeTask(element),
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.w,
                            horizontal: 15.w,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    IconData(
                                      element.icon,
                                      fontFamily: 'MaterialIcons',
                                    ),
                                    color: HexColor.fromHex(element.color),
                                    size: 20.sp,
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text(
                                    element.title,
                                    style: theme.textTheme.headline5,
                                  ),
                                ],
                              ),
                              if (homeCtrl.task.value == element)
                                const Icon(
                                  Icons.check,
                                  color: Colors.blue,
                                )
                            ],
                          )))))
                  .toList()
            ],
          ),
        ),
      ),
    );
  }

  Future pickDateTime() async {
    DateTime? date = await pickDate();
    if (date == null) return;

    TimeOfDay? time = await pickTime();
    if (time == null) return;
    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() {
      this.dateTime = dateTime;
    });
    homeCtrl.dateCtrl.text =
        '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100));
  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));
}
