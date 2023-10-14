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
    required this.todo,
    required this.allTodos,
    required this.calendare,
  });
  final Todos todo;
  final bool allTodos;
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
                      todo: widget.todo,
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
                          value: widget.todo.done,
                          shape: const CircleBorder(),
                          onChanged: (val) {
                            innerState(() {
                              widget.todo.done = val!;
                            });
                            widget.todo.done
                                ? flutterLocalNotificationsPlugin
                                    .cancel(widget.todo.id)
                                : widget.todo.todoCompletedTime != null
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
                                style: widget.todo.description.isNotEmpty
                                    ? context.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      )
                                    : context.textTheme.titleLarge?.copyWith(
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
                                  : const SizedBox.shrink(),
                              widget.allTodos || widget.calendare
                                  ? Text(
                                      widget.todo.task.value!.title,
                                      style:
                                          context.textTheme.bodyLarge?.copyWith(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              widget.todo.todoCompletedTime != null &&
                                      widget.calendare == false
                                  ? Text(
                                      widget.todo.todoCompletedTime != null
                                          ? DateFormat.yMMMEd(
                                                  locale.languageCode)
                                              .add_Hm()
                                              .format(widget
                                                  .todo.todoCompletedTime!)
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
                              .format(widget.todo.todoCompletedTime!),
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
