import 'package:flutter/material.dart';
import 'global/theme_data.dart';
import 'pages/book_shelf/book_shelf.dart';

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
  Widget build(BuildContext context) {
    return BookShelf();
  }
}
