import 'dart:io';

import 'package:book_reader/entity/book_info.dart';
import 'package:book_reader/global/file_util.dart';
import 'package:book_reader/global/global_info.dart';
import 'package:book_reader/pages/book_reader/book_reader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookShelf extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BookShelfState();
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
        ));
  }

  void _addBookToShelf() {
    BookInfo bookInfo = BookInfo();
    bookInfo.bookName = "绝对";

    setState(() {
      GlobalInfo.bookShelf.add(bookInfo);
    });
  }

  Widget _buildBookList() {
    return ListView.separated(
        itemBuilder: (context, i) {
          return _buildRow(context, i);
        },
        separatorBuilder: (buildContext, i) {
          return Divider(
            height: 2,
          );
        },
        itemCount: GlobalInfo.bookShelf.length);
  }

  Widget _buildRow(context, i) {
    return Container(
        child: GestureDetector(
      onTap: _toRead,
      child: Row(
        children: <Widget>[
          Image.network("https://bookcover.yuewen.com/qdbimg/349573/1016218809/180",height: 120,width: 60,),
          Column(
            children: <Widget>[
              Text("绝对一番"),
              Text("海底漫步者 11章未读"),
              Text("20小时前 第二百章 穿越者之耻")
            ],
          ),
          Expanded(
              child: PopupMenuButton<Choice>(
            onSelected: _select,
            itemBuilder: (context) {
              return choices.map((Choice choice) {
                return new PopupMenuItem<Choice>(
                  value: choice,
                  child: new Text(choice.title),
                );
              }).toList();
            },
          ))
        ],
      ),
    ));
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

  void _toRead() {
    Navigator.push(
        context,
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) {
            return BookReader(bookName: "app reader");
          },
        ));
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}
