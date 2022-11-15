import 'package:dark_todo/app/widgets/task_ce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class Task extends StatefulWidget {
  const Task({
    super.key,
    required this.element,
    required this.onDismissed,
    required this.onSave,
    required this.onChanged,
    required this.taskName,
    required this.taskDesk,
    required this.taskDoing,
  });
  final Object element;
  final Function(DismissDirection) onDismissed;
  final Function() onSave;
  final Function() onChanged;
  final String taskName;
  final String taskDesk;
  final String taskDoing;

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  late Color myColor;
  late bool isChecked = false;

  @override
  void initState() {
    myColor = Colors.blue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      <MaterialState>{
        MaterialState.pressed,
      };
      return Colors.black;
    }

    return Dismissible(
      key: ObjectKey(widget.element),
      direction: DismissDirection.endToStart,
      onDismissed: widget.onDismissed,
      background: Container(
        alignment: Alignment.centerRight,
        child: const Padding(
          padding: EdgeInsets.only(
            right: 15,
          ),
          child: Icon(
            Iconsax.trush_square,
            color: Colors.red,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(right: 20, left: 20, bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // color: Colors.white,
        ),
        child: CupertinoButton(
          minSize: double.minPositive,
          padding: EdgeInsets.zero,
          onPressed: () {
            showModalBottomSheet(
              enableDrag: false,
              backgroundColor: context.theme.scaffoldBackgroundColor,
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              builder: (BuildContext context) {
                return TaskCE(
                  text: 'Редактирование',
                  onSave: widget.onSave,
                  initValueName: widget.taskName,
                  initValueDesk: widget.taskDesk,
                  initValueTime: widget.taskDoing,
                );
              },
            );
          },
          child: Row(
            children: [
              Flexible(
                child: Row(
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: isChecked,
                      shape: const CircleBorder(),
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                        widget.onChanged;
                      },
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.taskName,
                            style: context.theme.textTheme.headline4?.copyWith(
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            widget.taskDesk,
                            style: context.theme.textTheme.subtitle2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                widget.taskDoing,
                style: context.theme.textTheme.subtitle2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
