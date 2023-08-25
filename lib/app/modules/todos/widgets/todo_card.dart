import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todark/app/data/schema.dart';
import 'package:todark/app/controller/controller.dart';
import 'package:todark/app/modules/todos/widgets/todos_action.dart';
import 'package:todark/app/services/notification.dart';
import 'package:todark/main.dart';

class TodoCard extends StatefulWidget {
  const TodoCard({
    super.key,
    required this.todosList,
    required this.allTask,
    required this.calendare,
  });
  final Todos todosList;
  final bool allTask;
  final bool calendare;

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  final todoController = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, innerState) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                showModalBottomSheet(
                  enableDrag: false,
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return TodosAction(
                      text: 'editing'.tr,
                      edit: true,
                      todo: widget.todosList,
                      category: true,
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
                          value: widget.todosList.done,
                          shape: const CircleBorder(),
                          onChanged: (val) {
                            innerState(() {
                              widget.todosList.done = val!;
                            });
                            widget.todosList.done == true
                                ? flutterLocalNotificationsPlugin
                                    .cancel(widget.todosList.id)
                                : widget.todosList.todoCompletedTime != null
                                    ? NotificationShow().showNotification(
                                        widget.todosList.id,
                                        widget.todosList.name!,
                                        widget.todosList.description!,
                                        widget.todosList.todoCompletedTime,
                                      )
                                    : null;
                            Future.delayed(
                              const Duration(milliseconds: 300),
                              () {
                                todoController
                                    .updateTodoCheck(widget.todosList);
                              },
                            );
                          },
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.todosList.name!,
                                style: context.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.visible,
                              ),
                              widget.todosList.description!.isNotEmpty
                                  ? Text(
                                      widget.todosList.description!,
                                      style: context.textTheme.labelLarge
                                          ?.copyWith(
                                        color: Colors.grey,
                                      ),
                                      overflow: TextOverflow.visible,
                                    )
                                  : const SizedBox.shrink(),
                              widget.allTask || widget.calendare
                                  ? Text(
                                      widget.todosList.task.value!.title!,
                                      style:
                                          context.textTheme.bodyLarge?.copyWith(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              widget.todosList.todoCompletedTime != null &&
                                      widget.calendare == false
                                  ? Text(
                                      widget.todosList.todoCompletedTime != null
                                          ? DateFormat.yMMMEd(
                                                  locale.languageCode)
                                              .add_Hm()
                                              .format(widget
                                                  .todosList.todoCompletedTime!)
                                          : '',
                                      style: context.textTheme.labelLarge,
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  widget.calendare
                      ? Text(
                          DateFormat.Hm(locale.languageCode)
                              .format(widget.todosList.todoCompletedTime!),
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
