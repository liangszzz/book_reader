
import 'package:book_reader/global/global_info.dart';
import 'package:flutter/material.dart';
import 'global/theme_data.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'BookReader Demo',
        theme: ThemeDataUtil.getMainThemeData(),
        home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GlobalInfo.bookShelf;
  }
}
