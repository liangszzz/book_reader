import 'package:flutter/material.dart';

class BookReader extends StatefulWidget {
  final String bookName;

  const BookReader({Key key, this.bookName}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BookReaderState();
}

class _BookReaderState extends State<BookReader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.bookName),
      ),
      body: Text("content"),
    );
  }
}
