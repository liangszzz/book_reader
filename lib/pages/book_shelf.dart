import 'package:book_reader/entity/book_info.dart';
import 'package:book_reader/global/global_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'book_reader.dart';

class BookShelf extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BookShelfState();
}

class _BookShelfState extends State<BookShelf> {
  bool _showCheckBox = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("书架"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _add,
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _search,
          )
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView.separated(
        itemBuilder: (context, i) => _buildRow(i),
        separatorBuilder: (context, i) => Divider(),
        itemCount: GlobalInfo.bookShelfDao.books.length);
  }

  _buildRow(int index) {
    BookInfo info = GlobalInfo.bookShelfDao.books[index];

    return Row(
      children: <Widget>[
        _showCheckBox
            ? Checkbox(
                value: info.check,
                onChanged: (b) {
                  setState(() {
                    info.check = b;
                  });
                })
            : SizedBox(
                width: 45,
              ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return BookReader(
                        bookInfo: info,
                      );
                    },
                  ));
            },
            child: Row(
              children: <Widget>[
                Image.network(
                  info.imgPath,
                  height: 120,
                  width: 70,
                ),
                SizedBox(
                  width: 30,
                ),
                Column(
                  children: <Widget>[
                    Text("${info.bookName}"),
                    Text("${info.author}"),
                    Text("${info.lastChapter}"),
                  ],
                )
              ],
            ),
          ),
        ),
        PopupMenuButton<String>(
          onSelected: null,
          itemBuilder: (str) {
            return <PopupMenuItem<String>>[
              PopupMenuItem(
                value: "delete",
                child: Text("书籍详情"),
              )
            ];
          },
        )
      ],
    );
  }

  void _search() {
    print("#search");
  }

  void _add() {
    String net = "https://www.biquge.info/71_71513/";
    Future<BookInfo> info = GlobalInfo.bookDao.addBook(net);
    info.then((value) {
      setState(() {
        GlobalInfo.bookShelfDao.addBook(value);
      });
    });
  }
}
