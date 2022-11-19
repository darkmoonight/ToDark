import 'package:dark_todo/app/widgets/text_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class TodosCe extends StatelessWidget {
  const TodosCe({
    super.key,
    required this.text,
    required this.save,
    required this.titleEdit,
    required this.descEdit,
    required this.timeEdit,
  });
  final String text;
  final Function() save;
  final TextEditingController titleEdit;
  final TextEditingController descEdit;
  final TextEditingController timeEdit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                            titleEdit.clear();
                            descEdit.clear();
                            timeEdit.clear();
                            Get.back();
                          },
                          icon: const Icon(
                            Icons.close,
                          ),
                        ),
                        Text(
                          text,
                          style: context.theme.textTheme.headline2,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      save();
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.save,
                    ),
                  ),
                ],
              ),
            ),
            MyTextForm(
              textEditingController: titleEdit,
              hintText: 'Имя',
              type: TextInputType.text,
              icon: const Icon(Iconsax.edit_2),
            ),
            MyTextForm(
              textEditingController: descEdit,
              hintText: 'Описание',
              type: TextInputType.text,
              icon: const Icon(Iconsax.note_text),
            ),
            MyTextForm(
              readOnly: true,
              textEditingController: timeEdit,
              hintText: 'Время выполнения',
              type: TextInputType.datetime,
              icon: const Icon(Iconsax.clock),
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
                    timeEdit.text = date.toString();
                  },
                  currentTime: DateTime.now(),
                  locale: LocaleType.ru,
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
