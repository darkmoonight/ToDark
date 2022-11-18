import 'package:dark_todo/app/data/schema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../main.dart';

class TodosList extends StatefulWidget {
  const TodosList({
    super.key,
    required this.isLoaded,
    required this.todos,
    required this.deleteTodo,
    required this.editTodo,
    required this.getTodo,
  });
  final bool isLoaded;
  final List<Todos> todos;
  final Function(Object) deleteTodo;
  final Function() editTodo;
  final Function() getTodo;

  @override
  State<TodosList> createState() => _TodosListState();
}

class _TodosListState extends State<TodosList> {
  updateTodo(todo) async {
    await isar.writeTxn(() async => isar.todos.put(todo));
    widget.getTodo();
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      <MaterialState>{
        MaterialState.pressed,
      };
      return Colors.black;
    }

    return Expanded(
      child: Visibility(
        visible: widget.isLoaded,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: Visibility(
          visible: widget.todos.isNotEmpty,
          replacement: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/AddTasks.png',
                    scale: 5,
                  ),
                  Text(
                    'Добавьте задачу',
                    style: context.theme.textTheme.headline4?.copyWith(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: widget.todos.length,
            itemBuilder: (BuildContext context, int index) {
              final todo = widget.todos[index];
              return Dismissible(
                key: ObjectKey(todo),
                direction: DismissDirection.endToStart,
                onDismissed: (DismissDirection direction) {
                  widget.deleteTodo(todo);
                },
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
                  margin:
                      const EdgeInsets.only(right: 20, left: 20, bottom: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    // color: Colors.white,
                  ),
                  child: CupertinoButton(
                    minSize: double.minPositive,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      widget.editTodo();
                    },
                    child: Row(
                      children: [
                        Flexible(
                          child: Row(
                            children: [
                              Checkbox(
                                checkColor: Colors.white,
                                fillColor:
                                    MaterialStateProperty.resolveWith(getColor),
                                value: todo.done,
                                shape: const CircleBorder(),
                                onChanged: (val) {
                                  setState(() {
                                    todo.done = val!;
                                  });
                                  todo.done = val!;
                                  Future.delayed(
                                      const Duration(milliseconds: 300), () {
                                    updateTodo(todo);
                                  });
                                },
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      todo.name,
                                      style: context.theme.textTheme.headline4
                                          ?.copyWith(
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      todo.description,
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
                          todo.todoCompletedTime != null
                              ? '${todo.todoCompletedTime?.day.toString().padLeft(2, '0')}/${todo.todoCompletedTime?.month.toString().padLeft(2, '0')}/${todo.todoCompletedTime?.year.toString().substring(2)} ${todo.todoCompletedTime?.hour.toString().padLeft(2, '0')}:${todo.todoCompletedTime?.minute.toString().padLeft(2, '0')}'
                              : '',
                          style: context.theme.textTheme.subtitle2,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
