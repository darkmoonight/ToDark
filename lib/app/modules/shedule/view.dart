import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horizontal_center_date_picker/datepicker_controller.dart';
import 'package:horizontal_center_date_picker/horizontal_date_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShedulePage extends StatefulWidget {
  const ShedulePage({super.key});

  @override
  State<ShedulePage> createState() => _ShedulePageState();
}

class _ShedulePageState extends State<ShedulePage> {
  var selectedDay = DateTime.now();
  DatePickerController datePickerController = DatePickerController();

  @override
  Widget build(BuildContext context) {
    var tag = Localizations.maybeLocaleOf(context)?.toLanguageTag();
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 15.w, bottom: 8.w),
              child: Text(
                AppLocalizations.of(context)!.todo_list,
                style: theme.textTheme.headline2,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5.w, horizontal: 10.w),
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: HorizontalDatePickerWidget(
                  locale: '$tag',
                  selectedColor: Colors.blue,
                  normalColor: theme.primaryColor,
                  disabledColor: theme.primaryColor,
                  normalTextColor: theme.dividerColor,
                  startDate: DateTime(2022, 09, 01),
                  endDate: DateTime(2100, 09, 01),
                  selectedDate: selectedDay,
                  widgetWidth: MediaQuery.of(context).size.width,
                  datePickerController: datePickerController,
                  onValueSelected: (date) {},
                ),
              ),
            ),
            Divider(
              color: theme.dividerColor,
              height: 20.w,
              thickness: 2,
              indent: 10.w,
              endIndent: 10.w,
            ),
          ],
        ),
      ),
    );
  }
}
