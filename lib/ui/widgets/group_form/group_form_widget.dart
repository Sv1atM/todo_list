import 'package:flutter/material.dart';
import 'package:todo_list/domain/notifier/model_provider.dart';
import 'package:todo_list/ui/widgets/group_form/group_form_widget_model.dart';

class GroupFormWidget extends StatefulWidget {
  const GroupFormWidget({Key? key}) : super(key: key);

  @override
  _GroupFormWidgetState createState() => _GroupFormWidgetState();
}

class _GroupFormWidgetState extends State<GroupFormWidget> {
  final _model = GroupFormWidgetModel();

  @override
  Widget build(BuildContext context) {
    return ModelProvider(
      model: _model,
      child: const _GroupFormWidgetBody(),
    );
  }
}

class _GroupFormWidgetBody extends StatelessWidget {
  const _GroupFormWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New group'),
        actions: [
          IconButton(
            onPressed: () => ModelProvider.get<GroupFormWidgetModel>(context)
                ?.saveGroup(context),
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _GroupNameWidget(),
        ),
      ),
    );
  }
}

class _GroupNameWidget extends StatelessWidget {
  const _GroupNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = ModelProvider.watch<GroupFormWidgetModel>(context);

    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: 'Group name',
        errorText: model?.errorText,
      ),
      onChanged: (value) => model?.groupName = value,
      onEditingComplete: () => model?.saveGroup(context),
    );
  }
}
