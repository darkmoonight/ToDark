import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:todark/app/data/db.dart';
import 'package:todark/app/controller/todo_controller.dart';
import 'package:todark/app/utils/notification.dart';
import 'package:todark/main.dart';

class TodoCard extends StatefulWidget {
  const TodoCard({
    super.key,
    required this.todo,
    required this.allTodos,
    required this.calendare,
    required this.onLongPress,
    required this.onTap,
  });
  final Todos todo;
  final bool allTodos;
  final bool calendare;
  final Function() onLongPress;
  final Function() onTap;

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  final todoController = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, innerState) {
        return GestureDetector(
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          child: Card(
            shape: todoController.isMultiSelectionTodo.isTrue &&
                    todoController.selectedTodo.contains(widget.todo)
                ? RoundedRectangleBorder(
                    side: BorderSide(
                        color: context.theme.colorScheme.onPrimaryContainer),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  )
                : null,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Row(
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        Checkbox(
                          value: widget.todo.done,
                          shape: const CircleBorder(),
                          onChanged: (val) {
                            innerState(() {
                              widget.todo.done = val!;
                            });
                            DateTime? date = widget.todo.todoCompletedTime;
                            widget.todo.done
                                ? flutterLocalNotificationsPlugin
                                    .cancel(widget.todo.id)
                                : (date != null &&
                                        DateTime.now().isBefore(date))
                                    ? NotificationShow().showNotification(
                                        widget.todo.id,
                                        widget.todo.name,
                                        widget.todo.description,
                                        widget.todo.todoCompletedTime,
                                      )
                                    : null;
                            Future.delayed(
                                const Duration(milliseconds: 300),
                                () => todoController
                                    .updateTodoCheck(widget.todo));
                          },
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.todo.name,
                                style: context.textTheme.titleLarge?.copyWith(
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.visible,
                              ),
                              widget.todo.description.isNotEmpty
                                  ? Text(
                                      widget.todo.description,
                                      style: context.textTheme.labelLarge
                                          ?.copyWith(
                                        color: Colors.grey,
                                      ),
                                      overflow: TextOverflow.visible,
                                    )
                                  : const Offstage(),
                              widget.allTodos || widget.calendare
                                  ? Row(
                                      children: [
                                        ColorIndicator(
                                          height: 8,
                                          width: 8,
                                          borderRadius: 20,
                                          color: Color(widget
                                              .todo.task.value!.taskColor),
                                          onSelectFocus: false,
                                        ),
                                        const Gap(5),
                                        Text(
                                          widget.todo.task.value!.title,
                                          style: context.textTheme.bodyLarge
                                              ?.copyWith(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Offstage(),
                              widget.todo.todoCompletedTime != null &&
                                      widget.calendare == false
                                  ? Text(
                                      widget.todo.todoCompletedTime != null
                                          ? timeformat == '12'
                                              ? DateFormat.yMMMEd(
                                                      locale.languageCode)
                                                  .add_jm()
                                                  .format(widget
                                                      .todo.todoCompletedTime!)
                                              : DateFormat.yMMMEd(
                                                      locale.languageCode)
                                                  .add_Hm()
                                                  .format(widget
                                                      .todo.todoCompletedTime!)
                                          : '',
                                      style: context.textTheme.labelLarge
                                          ?.copyWith(
                                        color:
                                            context.theme.colorScheme.secondary,
                                        fontSize: 12,
                                      ),
                                    )
                                  : const Offstage(),
                              widget.todo.priority != Priority.none
                                  ? _StatusChip(
                                      icon: IconsaxPlusLinear.flag,
                                      color: widget.todo.priority.color,
                                      label: widget.todo.priority.name.tr,
                                    )
                                  : const Offstage(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Column(
                      children: [
                        widget.calendare
                            ? Text(
                                timeformat == '12'
                                    ? DateFormat.jm(locale.languageCode)
                                        .format(widget.todo.todoCompletedTime!)
                                    : DateFormat.Hm(locale.languageCode)
                                        .format(widget.todo.todoCompletedTime!),
                                style: context.textTheme.labelLarge?.copyWith(
                                  color: context.theme.colorScheme.secondary,
                                  fontSize: 12,
                                ),
                              )
                            : const Offstage(),
                        const Gap(5),
                        widget.todo.fix
                            ? const Icon(
                                IconsaxPlusLinear.attach_square,
                                size: 20,
                                color: Colors.grey,
                              )
                            : const Offstage(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color? color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Chip(
        elevation: 4,
        avatar: Icon(icon, color: color),
        label: Text(label),
        padding: EdgeInsets.zero,
        labelPadding: const EdgeInsets.only(right: 10),
        visualDensity: const VisualDensity(
          vertical: -4,
          horizontal: -4,
        ),
      ),
    );
  }
}
