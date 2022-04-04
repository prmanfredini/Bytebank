import 'package:bytebank/database/app_database.dart';
import 'package:bytebank/http/webclient.dart';
import 'package:flutter/material.dart';

class AppDependecies extends InheritedWidget {
  final WebClient webClient;
  final DataBase dataBase;

  AppDependecies(
      {required this.webClient,
      required this.dataBase,
      required Widget child})
      : super(child: child);

  static AppDependecies? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppDependecies>();

  @override
  bool updateShouldNotify(AppDependecies oldWidget) {
    return webClient != oldWidget.webClient || dataBase != oldWidget.dataBase;
  }
}
