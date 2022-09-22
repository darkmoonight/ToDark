import 'package:dark_todo/app/core/utils/extensions.dart';
import 'package:dark_todo/app/data/models/task.dart';
import 'package:dark_todo/app/modules/home/controller.dart';
import 'package:dark_todo/app/widgets/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/values/colors.dart';

class AddCardList extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  AddCardList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final icons = getIcons();
    return WillPopScope(
      onWillPop: () async {
        homeCtrl.editCtrl.clear();
        homeCtrl.changeChipIndex(0);
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
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                        homeCtrl.editCtrl.clear();
                        homeCtrl.changeChipIndex(0);
                      },
                      icon: const Icon(Icons.close),
                      color: theme.iconTheme.color,
                      iconSize: theme.iconTheme.size,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(
                        AppLocalizations.of(context)!.taskType,
                        style: theme.textTheme.headline2,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 15.w, right: 15.w, bottom: 15.w, top: 5.w),
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
                    hintText: AppLocalizations.of(context)!.taskType,
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 15.sp,
                    ),
                  ),
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLocalizations.of(context)!.showEnterType;
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 15.w,
                  right: 15.w,
                  bottom: 5.w,
                ),
                child: Text(
                  AppLocalizations.of(context)!.icons,
                  style: theme.textTheme.subtitle1,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 15.w),
                child: Wrap(
                  spacing: 8.w,
                  children: icons
                      .map(
                        (e) => Obx(
                          () {
                            final index = icons.indexOf(e);
                            return ChoiceChip(
                              selectedColor: theme.selectedRowColor,
                              pressElevation: 0,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
                              backgroundColor: theme.primaryColor,
                              label: e,
                              selected: homeCtrl.chipIndex.value == index,
                              onSelected: (bool selected) {
                                homeCtrl.chipIndex.value = selected ? index : 0;
                              },
                            );
                          },
                        ),
                      )
                      .toList(),
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
              if (homeCtrl.formKey.currentState!.validate()) {
                if (homeCtrl.task.value == null) {
                  int icon = icons[homeCtrl.chipIndex.value].icon!.codePoint;
                  String color = icons[homeCtrl.chipIndex.value].color!.toHex();
                  var task = Task(
                    title: homeCtrl.editCtrl.text,
                    icon: icon,
                    color: color,
                  );
                  Get.back();
                  homeCtrl.editCtrl.clear();
                  homeCtrl.addTask(task)
                      ? EasyLoading.showSuccess(
                          AppLocalizations.of(context)!.createSucess)
                      : EasyLoading.showError(
                          AppLocalizations.of(context)!.duplicated);
                }
              }
            },
            backgroundColor: blue,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
