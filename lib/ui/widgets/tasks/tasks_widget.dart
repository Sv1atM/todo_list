import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/domain/notifier/model_provider.dart';
import 'package:todo_list/ui/widgets/tasks/tasks_widget_model.dart';

class TasksWidgetConfig {
  final int groupKey;
  final String title;

  TasksWidgetConfig({
    required this.groupKey,
    required this.title,
  });
}

class TasksWidget extends StatefulWidget {
  final TasksWidgetConfig config;

  const TasksWidget({
    Key? key,
    required this.config,
  }) : super(key: key);

  @override
  _TasksWidgetState createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  late final TasksWidgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = TasksWidgetModel(config: widget.config);
  }

  @override
  Widget build(BuildContext context) {
    return ModelProvider(
      model: _model,
      child: const _TasksWidgetBody(),
    );
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }
}

class _TasksWidgetBody extends StatelessWidget {
  const _TasksWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = ModelProvider.watch<TasksWidgetModel>(context);
    final title = model?.config.title ?? 'Tasks';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const _TaskListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => model?.showForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TaskListWidget extends StatelessWidget {
  const _TaskListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tasksCount =
        ModelProvider.watch<TasksWidgetModel>(context)?.tasks.length ?? 0;

    return ListView.separated(
      itemCount: tasksCount,
      itemBuilder: (BuildContext context, int index) =>
          _TaskListRowWidget(indexInList: index),
      separatorBuilder: (BuildContext context, int index) =>
          const Divider(height: 3),
    );
  }
}

class _TaskListRowWidget extends StatelessWidget {
  final int indexInList;

  const _TaskListRowWidget({
    Key? key,
    required this.indexInList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = ModelProvider.get<TasksWidgetModel>(context)!;
    final task = model.tasks[indexInList];
    final icon = task.isDone ? Icons.done : null;
    final style = task.isDone
        ? const TextStyle(decoration: TextDecoration.lineThrough)
        : const TextStyle(decoration: TextDecoration.none);

    return Slidable(
      actionPane: const SlidableBehindActionPane(),
      secondaryActions: [
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => model.deleteTask(indexInList),
        ),
      ],
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: ListTile(
          title: Text(task.text, style: style),
          trailing: Icon(icon),
          onTap: () => model.doneToggle(indexInList),
        ),
      ),
    );
  }
}
