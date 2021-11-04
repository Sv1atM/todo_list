import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/domain/notifier/model_provider.dart';
import 'package:todo_list/ui/widgets/groups/groups_widget_model.dart';

class GroupsWidget extends StatefulWidget {
  const GroupsWidget({Key? key}) : super(key: key);

  @override
  _GroupsWidgetState createState() => _GroupsWidgetState();
}

class _GroupsWidgetState extends State<GroupsWidget> {
  final _model = GroupsWidgetModel();

  @override
  Widget build(BuildContext context) {
    return ModelProvider(
      model: _model,
      child: const _GroupsWidgetBody(),
    );
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }
}

class _GroupsWidgetBody extends StatelessWidget {
  const _GroupsWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
      ),
      body: const _GroupListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            ModelProvider.get<GroupsWidgetModel>(context)?.showForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _GroupListWidget extends StatelessWidget {
  const _GroupListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupsCount =
        ModelProvider.watch<GroupsWidgetModel>(context)?.groups.length ?? 0;

    return ListView.separated(
      itemCount: groupsCount,
      itemBuilder: (BuildContext context, int index) =>
          _GroupListRowWidget(indexInList: index),
      separatorBuilder: (BuildContext context, int index) =>
          const Divider(height: 3),
    );
  }
}

class _GroupListRowWidget extends StatelessWidget {
  final int indexInList;

  const _GroupListRowWidget({
    Key? key,
    required this.indexInList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = ModelProvider.get<GroupsWidgetModel>(context)!;
    final group = model.groups[indexInList];

    return Slidable(
      actionPane: const SlidableBehindActionPane(),
      secondaryActions: [
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => model.deleteGroup(indexInList),
        ),
      ],
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: ListTile(
          title: Text(group.name),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => model.showTasks(context, indexInList),
        ),
      ),
    );
  }
}
