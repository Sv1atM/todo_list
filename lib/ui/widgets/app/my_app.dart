import 'package:flutter/material.dart';
import 'package:todo_list/ui/navigation/main_navigation.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(centerTitle: true),
        primarySwatch: Colors.blue,
      ),
      routes: MainNavigation.routes,
      initialRoute: MainNavigation.initialRoute,
      onGenerateRoute: MainNavigation.onGenerateRoute,
    );
  }
}
