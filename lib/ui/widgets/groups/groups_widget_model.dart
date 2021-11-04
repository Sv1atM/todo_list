import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/domain/data_provider/box_manager.dart';
import 'package:todo_list/domain/entity/group.dart';
import 'package:todo_list/ui/navigation/main_navigation.dart';
import 'package:todo_list/ui/widgets/tasks/tasks_widget.dart';

class GroupsWidgetModel extends ChangeNotifier {
  late final Future<Box<Group>> _box;
  ValueListenable<Object>? _listenableBox;
  var _groups = <Group>[];

  List<Group> get groups => _groups.toList();

  GroupsWidgetModel() {
    _setup();
  }

  Future<void> showForm(BuildContext context) async =>
      await Navigator.of(context).pushNamed(MainNavigationRoutes.groupsForm);

  Future<void> showTasks(BuildContext context, int groupIndex) async {
    final group = (await _box).getAt(groupIndex);
    if (group == null) return;
    final config = TasksWidgetConfig(
      groupKey: group.key as int,
      title: group.name,
    );
    await Navigator.of(context)
        .pushNamed(MainNavigationRoutes.tasks, arguments: config);
  }

  Future<void> deleteGroup(int index) async {
    final box = await _box;
    final groupKey = box.keyAt(index) as int;
    final taskBox = BoxManager.instance.makeTaskBoxName(groupKey);
    await Hive.deleteBoxFromDisk(taskBox);
    await box.deleteAt(index);
  }

  Future<void> _readGroups() async {
    _groups = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> _setup() async {
    _box = BoxManager.instance.openGroupBox();
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(_readGroups);
    await _readGroups();
  }

  @override
  Future<void> dispose() async {
    _listenableBox?.removeListener(_readGroups);
    await BoxManager.instance.closeBox(await _box);
    super.dispose();
  }
}
