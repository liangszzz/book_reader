import 'dart:io';

import 'package:book_reader/entity/book_info.dart';
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
  List<Choice> choices = const <Choice>[
    const Choice(title: '添加', icon: Icons.add),
    const Choice(title: '全选', icon: Icons.select_all),
    const Choice(title: '清除', icon: Icons.clear_all),
    const Choice(title: '保存', icon: Icons.save),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("shelf"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _search,
          ),
          PopupMenuButton<Choice>(
            onSelected: _select,
            itemBuilder: (context) {
              return choices.map((Choice choice) {
                return new PopupMenuItem<Choice>(
                  value: choice,
                  child: new Text(choice.title),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Center(
        child: _buildBookList(),
      ),
      bottomNavigationBar: Text("bottom"),
    );
  }

  void _addBookToShelf() {
    BookInfo bookInfo = BookInfo();
    bookInfo.bookName = "绝对";

    setState(() {
      GlobalInfo.bookShelf.add(bookInfo);
    });
  }

  Widget _buildBookList() {
    return ListView.builder(
        itemCount: GlobalInfo.bookShelf.length,
        itemBuilder: (context, i) {
          return _buildRow(context, i);
        });
  }

  Widget _buildRow(context, i) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(GlobalInfo.bookShelf.elementAt(i).bookName),
            SizedBox(
              width: 100,
            ),
            Text("阅读")
          ],
        ),
        Divider()
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    if (GlobalInfo.bookShelf == null || GlobalInfo.bookShelf.isEmpty) {
      FileUtil.getBooksFromFile().then((value) {
        setState(() {
          GlobalInfo.bookShelf = value;
        });
      });
    }
    sleep(Duration(milliseconds: 50));
  }

  void _select(Choice value) {
    if (value.icon == Icons.add) {
      _addBookToShelf();
    } else if (value.icon == Icons.save) {
      FileUtil.saveBookShelfToFile();
    } else
      print(value.title);
  }

  void _search() {
    print("#search");
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}
