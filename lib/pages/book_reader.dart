import 'package:book_reader/entity/book_info.dart';
import 'package:flutter/material.dart';

class BookReader extends StatefulWidget {
  final BookInfo bookInfo;

  const BookReader({Key key, this.bookInfo}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BookReaderState();
}

class _BookReaderState extends State<BookReader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.widget.bookInfo.lastReadChapterName),
        ),
        body: Container(
          child: Text(this.widget.bookInfo.lastChapter),
        ));
  }
}
