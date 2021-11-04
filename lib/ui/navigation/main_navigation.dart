import 'package:flutter/material.dart';
import 'package:todo_list/ui/widgets/group_form/group_form_widget.dart';
import 'package:todo_list/ui/widgets/groups/groups_widget.dart';
import 'package:todo_list/ui/widgets/task_form/task_form_widget.dart';
import 'package:todo_list/ui/widgets/tasks/tasks_widget.dart';

abstract class MainNavigationRoutes {
  static const groups = '/';
  static const groupsForm = '/groups_form';
  static const tasks = '/tasks';
  static const tasksForm = '/tasks/form';
}

abstract class MainNavigation {
  static String get initialRoute => MainNavigationRoutes.groups;

  static Map<String, WidgetBuilder> get routes => {
        MainNavigationRoutes.groups: (context) => const GroupsWidget(),
        MainNavigationRoutes.groupsForm: (context) => const GroupFormWidget(),
      };

  static Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRoutes.tasks:
        final config = settings.arguments as TasksWidgetConfig;
        return _buildRoute(TasksWidget(config: config));
      case MainNavigationRoutes.tasksForm:
        final groupKey = settings.arguments as int;
        return _buildRoute(TaskFormWidget(groupKey: groupKey));
      default:
        const widget = Center(child: Text('Navigation Error!'));
        return _buildRoute(widget);
    }
  }

  static MaterialPageRoute<T> _buildRoute<T>(Widget widget) =>
      MaterialPageRoute<T>(builder: (context) => widget);
}
