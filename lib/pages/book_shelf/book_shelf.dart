import 'dart:io';

import 'package:book_reader/global/file_util.dart';
import 'package:book_reader/global/global_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookShelf extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BookShelfState();
  }
}

class _BookShelfState extends State<BookShelf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("book shelf"),
      ),
      body: Center(
        child: _buildBookList(),
      ),
    );
  }

  Widget _buildBookList() {
    return ListView.builder(
        itemCount: GlobalInfo.bookShelf.length,
        itemBuilder: (context, i) {
          return _buildRow(context, i);
        });
  }

  Widget _buildRow(context, i) {
    return Row(
      children: <Widget>[
        Text(GlobalInfo.bookShelf.elementAt(i).bookName),
        Text("阅读")
      ],
    );
  }

  @override
  void initState() {
    if (GlobalInfo.bookShelf == null || GlobalInfo.bookShelf.isEmpty) {
      FileUtil.getBooksFromFile().then((value) {
        GlobalInfo.bookShelf = value;
      });
    }
    sleep(Duration(milliseconds: 50));
    super.initState();
  }
}
