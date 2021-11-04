import 'package:flutter/material.dart';
import 'package:todo_list/domain/notifier/model_provider.dart';
import 'package:todo_list/ui/widgets/task_form/task_form_widget_model.dart';

class TaskFormWidget extends StatefulWidget {
  final int groupKey;

  const TaskFormWidget({
    Key? key,
    required this.groupKey,
  }) : super(key: key);

  @override
  _TaskFormWidgetState createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  late final TaskFormWidgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = TaskFormWidgetModel(groupKey: widget.groupKey);
  }

  @override
  Widget build(BuildContext context) {
    return ModelProvider(
      model: _model,
      child: const _TaskFormWidgetBody(),
    );
  }
}

class _TaskFormWidgetBody extends StatelessWidget {
  const _TaskFormWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = ModelProvider.watch<TaskFormWidgetModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New task'),
        actions: [
          if (model?.isTaskTextValid ?? true)
            IconButton(
              onPressed: () => model?.saveTask(context),
              icon: const Icon(Icons.done),
            ),
        ],
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _TaskTextWidget(),
        ),
      ),
    );
  }
}

class _TaskTextWidget extends StatelessWidget {
  const _TaskTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = ModelProvider.get<TaskFormWidgetModel>(context);

    return TextField(
      autofocus: true,
      minLines: null,
      maxLines: null,
      expands: true,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Enter new task text',
      ),
      onChanged: (value) => model?.taskText = value,
      onEditingComplete: () => model?.saveTask(context),
    );
  }
}
