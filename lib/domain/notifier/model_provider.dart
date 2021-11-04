import 'package:flutter/material.dart';

class ModelProvider<T extends ChangeNotifier> extends InheritedNotifier {
  ModelProvider({
    Key? key,
    required ChangeNotifier? model,
    required Widget child,
  }) : super(key: key, notifier: model, child: child);

  static T? watch<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ModelProvider>()?.notifier
        as T?;
  }

  static T? get<T>(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<ModelProvider>()
        ?.widget;
    return (widget is ModelProvider) ? widget.notifier as T? : null;
  }
}
