import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/domain/entity/group.dart';
import 'package:todo_list/domain/entity/task.dart';

class BoxManager {
  static final BoxManager instance = BoxManager._();
  final _boxCounter = <String, int>{};

  BoxManager._();

  Future<Box<Group>> openGroupBox() async =>
      _openBox('groups_box', GroupAdapter());

  Future<Box<Task>> openTaskBox(int groupKey) async =>
      _openBox(makeTaskBoxName(groupKey), TaskAdapter());

  Future<void> closeBox<T>(Box<T> box) async {
    if (!box.isOpen) {
      _boxCounter.remove(box.name);
      return;
    }
    var count = _boxCounter[box.name] ?? 1;
    _boxCounter[box.name] = --count;
    if (count > 0) return;
    _boxCounter.remove(box.name);
    await box.compact();
    await box.close();
  }

  String makeTaskBoxName(int groupKey) => 'tasks_box_$groupKey';

  Future<Box<T>> _openBox<T>(String name, TypeAdapter<T> adapter) async {
    if (Hive.isBoxOpen(name)) {
      final count = _boxCounter[name] ?? 1;
      _boxCounter[name] = count + 1;
      return Hive.box(name);
    }
    _boxCounter[name] = 1;
    if (!Hive.isAdapterRegistered(adapter.typeId)) {
      Hive.registerAdapter(adapter);
    }
    return Hive.openBox(name);
  }
}
