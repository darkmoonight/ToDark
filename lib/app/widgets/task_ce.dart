import 'package:dark_todo/app/widgets/text_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TaskCE extends StatefulWidget {
  const TaskCE({
    super.key,
    required this.text,
    required this.onSave,
    this.initValueName = '',
    this.initValueDesk = '',
    this.initValueTime = '',
  });
  final String text;
  final String initValueName;
  final String initValueDesk;
  final String initValueTime;
  final Function() onSave;

  @override
  State<TaskCE> createState() => _TaskCEState();
}

class _TaskCEState extends State<TaskCE> {
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
              hintText: 'Имя',
              initValue: widget.initValueName,
              type: TextInputType.text,
              icon: const Icon(Iconsax.edit_2),
              password: false,
              autofocus: false,
            ),
            MyTextForm(
              hintText: 'Описание',
              initValue: widget.initValueDesk,
              type: TextInputType.text,
              icon: const Icon(Iconsax.note_text),
              password: false,
              autofocus: false,
            ),
            MyTextForm(
              hintText: 'Время выполнения',
              initValue: widget.initValueTime,
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
