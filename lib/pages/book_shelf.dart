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
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.text = "https://www.biquge.info/";
    return Scaffold(
        appBar: AppBar(
          title: Text("书架"),
          actions: <Widget>[
            SizedBox(
              width: 180,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '书籍网址',
                ),
              ),
            ),
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
        body: _buildBody());
  }

  Widget _buildBody() {
    return ListView.separated(
        itemBuilder: (context, i) => _buildRow(i),
        separatorBuilder: (context, i) => Divider(),
        itemCount: GlobalInfo.bookShelfDao.books.length);
  }

  _buildRow(int index) {
    BookInfo info = GlobalInfo.bookShelfDao.books[index];

    String lastChapterName = info.lastChapter.name;
    if (lastChapterName.length > 18) {
      lastChapterName = lastChapterName.substring(0, 18) + "...";
    }

    return Row(
      children: <Widget>[
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
                    Text("$lastChapterName"),
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

  bool _flag = true;

  void _add() {
    if (_flag) {
      _flag = false;
      String net = _controller.text;
      Future<BookInfo> info = GlobalInfo.bookDao.addBook(net);
      info.then((value) {
        setState(() {
          GlobalInfo.bookShelfDao.addBook(value);
          _controller.text = "https://www.biquge.info/";
        });
        _flag = true;
      });
    }
  }
}
