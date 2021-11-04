import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/domain/data_provider/box_manager.dart';
import 'package:todo_list/domain/entity/task.dart';
import 'package:todo_list/ui/navigation/main_navigation.dart';
import 'package:todo_list/ui/widgets/tasks/tasks_widget.dart';

class TasksWidgetModel extends ChangeNotifier {
  TasksWidgetConfig config;
  late final Future<Box<Task>> _box;
  ValueListenable<Object>? _listenableBox;
  var _tasks = <Task>[];

  List<Task> get tasks => _tasks.toList();

  TasksWidgetModel({required this.config}) {
    _setup();
  }

  Future<void> showForm(BuildContext context) async =>
      await Navigator.of(context).pushNamed(
        MainNavigationRoutes.tasksForm,
        arguments: config.groupKey,
      );

  Future<void> deleteTask(int index) async =>
      await (await _box).deleteAt(index);

  Future<void> doneToggle(int index) async {
    final task = (await _box).getAt(index);
    task?.isDone = !task.isDone;
    await task?.save();
  }

  Future<void> _readTasks() async {
    _tasks = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> _setup() async {
    _box = BoxManager.instance.openTaskBox(config.groupKey);
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(_readTasks);
    await _readTasks();
  }

  @override
  Future<void> dispose() async {
    _listenableBox?.removeListener(_readTasks);
    await BoxManager.instance.closeBox(await _box);
    super.dispose();
  }
}
