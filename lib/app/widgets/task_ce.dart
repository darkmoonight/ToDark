import 'package:dark_todo/app/widgets/text_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TaskCE extends StatefulWidget {
  const TaskCE({
    super.key,
    required this.text,
    required this.onSave,
  });
  final String text;

  final Function() onSave;

  @override
  State<TaskCE> createState() => _TaskCEState();
}

class _TaskCEState extends State<TaskCE> {
  TextEditingController titleEdit = TextEditingController();
  TextEditingController descEdit = TextEditingController();
  TextEditingController timeEdit = TextEditingController();

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
                      widget.onSave();
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
              password: false,
              autofocus: false,
            ),
            MyTextForm(
              textEditingController: descEdit,
              hintText: 'Описание',
              type: TextInputType.text,
              icon: const Icon(Iconsax.note_text),
              password: false,
              autofocus: false,
            ),
            MyTextForm(
              textEditingController: titleEdit,
              hintText: 'Время выполнения',
              type: TextInputType.datetime,
              icon: const Icon(Iconsax.clock),
              password: false,
              autofocus: false,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
