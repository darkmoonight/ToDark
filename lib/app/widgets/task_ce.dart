import 'package:dark_todo/app/widgets/text_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TaskCE extends StatefulWidget {
  const TaskCE({super.key});

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
              padding: const EdgeInsets.only(bottom: 10, top: 15),
              child: Text(
                'Создание',
                style: context.theme.textTheme.headline2,
              ),
            ),
            const MyTextForm(
              hintText: 'Имя',
              type: TextInputType.text,
              icon: Icon(Iconsax.edit_2),
              password: false,
              autofocus: false,
            ),
            const MyTextForm(
              hintText: 'Описание',
              type: TextInputType.text,
              icon: Icon(Iconsax.note_text),
              password: false,
              autofocus: false,
            ),
            const MyTextForm(
              hintText: 'Время выполнения',
              type: TextInputType.datetime,
              icon: Icon(Iconsax.clock),
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
