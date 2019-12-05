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
  List<BookInfo> shelf = List<BookInfo>();

  @override
  void initState() {
    super.initState();
    BookShelfDao.loadBookShelf().then((value) {
      setState(() {
        shelf = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("shelf"),
          actions: <Widget>[
            IconButton(
              // action button
              icon: Icon(Icons.search),
              onPressed: _search,
            ),
            PopupMenuButton<String>(
              onSelected: _selectBtn,
              itemBuilder: (context) {
                return <PopupMenuEntry<String>>[
                  PopupMenuItem(
                    value: "add",
                    child: Text("添加"),
                  ),
                  PopupMenuItem(
                    value: "select_all",
                    child: Text("全选"),
                  ),
                  PopupMenuItem(
                    value: "save_all",
                    child: Text("保存"),
                  )
                ];
              },
            )
          ],
        ),
        body: Center(
          child: _buildBookList(),
        ));
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
        itemCount: shelf.length);
  }

  Widget _buildRow(context, i) {
    BookInfo bookInfo = shelf[i];
    return Container(
        child: GestureDetector(
      onTap: _toRead,
      child: Row(
        children: <Widget>[
          bookInfo.imgPath == null
              ? Image.network(
                  "https://cdn.jsdelivr.net/gh/flutterchina/website@1.0/images/flutter-mark-square-100.png")
              : Image.network(bookInfo.imgPath),
          Expanded(
            child: Column(
              children: <Widget>[
                Text(bookInfo.bookName),
                Text("  3张未读"),
                Text("20小时前 第二百章 穿越者之耻")
              ],
            ),
          ),
          IconButton(icon: Icon(Icons.delete), onPressed: _deleteBook(i))
        ],
      ),
    ));
  }

  void _addBookToShelf() {
    BookInfo bookInfo = BookInfo();
    bookInfo.bookName = "绝对一番";
    bookInfo.author = "海底捞";
    bookInfo.imgPath =
        "https://www.biquge.info/files/article/image/71/71513/71513s.jpg";

    setState(() {
      shelf.add(bookInfo);
    });
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
            return BookReader(bookName: "绝对一番");
          },
        ));
  }

  void _selectBtn(String f) {
    switch (f) {
      case "add":
        _addBookToShelf();
        break;
      case "select_all":
        _selectAll();
        break;
      case "save_all":
        _saveShelf();
        break;
    }
  }

  void _selectAll() {}

  _deleteBook(index) {
    shelf.removeAt(index);
  }

  void _saveShelf() {
    BookShelfDao.saveBookShelfToFile(shelf);
  }
}
