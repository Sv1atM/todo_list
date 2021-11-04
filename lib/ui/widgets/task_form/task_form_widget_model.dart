import 'package:flutter/material.dart';
import 'package:todo_list/domain/data_provider/box_manager.dart';
import 'package:todo_list/domain/entity/task.dart';

class TaskFormWidgetModel extends ChangeNotifier {
  int groupKey;
  var _taskText = '';

  bool get isTaskTextValid => _taskText.trim().isNotEmpty;

  set taskText(String value) {
    final taskTextState = isTaskTextValid;
    _taskText = value;
    if (isTaskTextValid != taskTextState) {
      notifyListeners();
    }
  }

  TaskFormWidgetModel({required this.groupKey});

  void saveTask(BuildContext context) async {
    final taskText = _taskText.trim();
    if (taskText.isEmpty) return;
    final box = await BoxManager.instance.openTaskBox(groupKey);
    final task = Task(text: taskText);
    await box.add(task);
    await BoxManager.instance.closeBox(box);
    Navigator.of(context).pop();
  }
}
