import 'package:dark_todo/app/data/schema.dart';
import 'package:dark_todo/app/widgets/text_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class TodosCe extends StatefulWidget {
  const TodosCe({
    super.key,
    required this.text,
    required this.save,
    required this.titleEdit,
    required this.descEdit,
    required this.timeEdit,
    this.tasks,
    required this.isCategory,
  });
  final String text;
  final bool isCategory;
  final List<Tasks>? tasks;
  final Function() save;
  final TextEditingController titleEdit;
  final TextEditingController descEdit;
  final TextEditingController timeEdit;

  @override
  State<TodosCe> createState() => _TodosCeState();
}

class _TodosCeState extends State<TodosCe> {
  final formKey = GlobalKey<FormState>();

  textTrim(value) {
    value.text = value.text.trim();
    while (value.text.contains("  ")) {
      value.text = value.text.replaceAll("  ", " ");
    }
  }

  @override
  Widget build(BuildContext context) {
    final tag = Localizations.maybeLocaleOf(context)?.toLanguageTag();
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 5, right: 10),
                child: Row(
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              widget.titleEdit.clear();
                              widget.descEdit.clear();
                              widget.timeEdit.clear();
                              Get.back();
                            },
                            icon: const Icon(
                              Icons.close,
                            ),
                          ),
                          Text(
                            widget.text,
                            style: context.theme.textTheme.headline2,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          textTrim(widget.titleEdit);
                          textTrim(widget.descEdit);
                          widget.save();
                          Get.back();
                        }
                      },
                      icon: const Icon(
                        Icons.save,
                      ),
                    ),
                  ],
                ),
              ),
              MyTextForm(
                textEditingController: widget.titleEdit,
                hintText: 'name'.tr,
                type: TextInputType.text,
                icon: const Icon(Iconsax.edit_2),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'validateName'.tr;
                  }
                  return null;
                },
              ),
              MyTextForm(
                textEditingController: widget.descEdit,
                hintText: 'description'.tr,
                type: TextInputType.text,
                icon: const Icon(Iconsax.note_text),
              ),
              MyTextForm(
                readOnly: true,
                textEditingController: widget.timeEdit,
                hintText: 'timeComlete'.tr,
                type: TextInputType.datetime,
                icon: const Icon(Iconsax.clock),
                iconButton: widget.timeEdit.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 18,
                        ),
                        onPressed: () {
                          widget.timeEdit.clear();
                        },
                      )
                    : null,
                onTap: () {
                  DatePicker.showDateTimePicker(
                    context,
                    showTitleActions: true,
                    theme: DatePickerTheme(
                      backgroundColor: context.theme.scaffoldBackgroundColor,
                      cancelStyle: const TextStyle(color: Colors.red),
                      itemStyle: TextStyle(
                          color: context.theme.textTheme.headline6?.color),
                    ),
                    minTime: DateTime.now(),
                    maxTime: DateTime.now().add(const Duration(days: 1000)),
                    onConfirm: (date) {
                      widget.timeEdit.text = date.toString();
                    },
                    currentTime: DateTime.now(),
                    locale: tag.toString() == 'ru-RU'
                        ? LocaleType.ru
                        : LocaleType.en,
                  );
                },
              ),
              widget.isCategory == true
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      margin: const EdgeInsets.only(top: 10),
                      width: Get.size.width - 23,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: context.theme.disabledColor, width: 1),
                      ),
                      child: DropdownButton(
                        focusColor: Colors.transparent,
                        hint: Text(
                          'Выберете категорию',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 15.sp,
                          ),
                        ),
                        underline: Container(),
                        dropdownColor: context.theme.scaffoldBackgroundColor,
                        icon: const Icon(
                          Iconsax.arrow_down_1,
                        ),
                        isExpanded: true,
                        items: widget.tasks?.map((e) {
                          return DropdownMenuItem(
                              value: e, child: Text(e.title));
                        }).toList(),
                        onChanged: (_) {},
                      ),
                    )
                  : Container(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
