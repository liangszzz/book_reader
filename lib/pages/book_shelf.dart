import 'dart:io';

import 'package:book_reader/dao/book_shelf_dao.dart';
import 'package:book_reader/entity/book_info.dart';
import 'package:book_reader/pages/book_reader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookShelf extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BookShelfState();
}

class _BookShelfState extends State<BookShelf> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("书架"),
      ),
    );
  }

}
