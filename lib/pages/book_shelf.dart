import 'package:book_reader/entity/book_info.dart';
import 'package:book_reader/global/global_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'book_reader.dart';

class BookShelf extends StatefulWidget {
  final List<BookInfo> books = List();

  @override
  State<StatefulWidget> createState() => _BookShelfState();

  void save() {
    GlobalInfo.bookShelfDao.saveBookShelfToFile(books);
  }
}

class _BookShelfState extends State<BookShelf> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    var loadBookShelf = GlobalInfo.bookShelfDao.loadBookShelf();
    super.initState();
    setState(() {
      loadBookShelf.then((value) {
        this.widget.books.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  hintText: '书籍网址',
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _add,
            ),            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: (){

              },
            )
          ],
        ),
        body: _buildBody());
  }

  Widget _buildBody() {
    return ListView.separated(
        itemBuilder: (context, i) => _buildRow(i),
        separatorBuilder: (context, i) => Divider(),
        itemCount: this.widget.books.length);
  }

  _buildRow(int index) {
    BookInfo info = this.widget.books[index];
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
        PopupMenuButton<ShelfBtn>(
          onSelected: _selectBtn,
          itemBuilder: (str) {
            return <PopupMenuItem<ShelfBtn>>[
              PopupMenuItem(
                value: ShelfBtn(info, "info"),
                child: Text("书籍详情"),
              ),
              PopupMenuItem(
                value: ShelfBtn(info, "update"),
                child: Text("更新"),
              ),
              PopupMenuItem(
                value: ShelfBtn(info, "delete"),
                child: Text("删除"),
              )
            ];
          },
        )
      ],
    );
  }

  bool _flag = true;

  void _add() {
    if (_flag) {
      _flag = false;
      String net = _controller.text;
      Future<BookInfo> info = GlobalInfo.bookDao.addBook(net);
      info.then((value) {
        setState(() {
          this.widget.books.add(value);
          _controller.text = "";
        });
        _flag = true;
        this.widget.save();
      });
    }
  }

  void _selectBtn(ShelfBtn shelfBtn) async {
    if (shelfBtn.btnName == "delete") {
      setState(() {
        this.widget.books.remove(shelfBtn.info);
      });
      this.widget.save();
    } else if (shelfBtn.btnName == "update") {
      var aBook = await GlobalInfo.bookDao.addBook(shelfBtn.info.netPath);
      var lastReadChapter = shelfBtn.info.lastReadChapter;
      var lastReadTime = shelfBtn.info.lastReadTime;
      setState(() {
        aBook.lastReadChapter = lastReadChapter;
        aBook.lastReadTime = lastReadTime;
        shelfBtn.info = aBook;
      });
      this.widget.save();
    }
  }
}

class ShelfBtn {
  BookInfo info;

  String btnName;

  ShelfBtn(BookInfo info, String btnName) {
    this.info = info;
    this.btnName = btnName;
  }
}
