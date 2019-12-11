import 'dart:io';

import 'package:book_reader/entity/book_info.dart';
import 'package:book_reader/global/global_info.dart';
import 'package:book_reader/pages/app_setting.dart';
import 'package:book_reader/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'book_reader.dart';

class BookShelf extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BookShelfState();
}

class _BookShelfState extends State<BookShelf> {
  final List<BookInfo> books = List();

  TextEditingController _controller = TextEditingController();

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    loadBookShelf();
  }

  void loadBookShelf() async {
    var list = await GlobalInfo.bookDao.loadBookShelf();
    setState(() {
      books.addAll(list);
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
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) =>
                          AppSetting(),
                    ));
              },
            )
          ],
        ),
        body: _loading ? Loading() : _buildBody());
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.all(10),
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.separated(
            itemBuilder: (context, i) => _buildRow(i),
            separatorBuilder: (context, i) => Divider(),
            itemCount: books.length),
      ),
    );
  }

  _buildRow(int index) {
    BookInfo info = books[index];
    String lastChapterName = "";
    if (info.lastUpdateChapter != null) {
      if (info.lastUpdateChapter.length > 15) {
        lastChapterName = info.lastUpdateChapter.substring(0, 12) + "...";
      } else {
        lastChapterName = info.lastUpdateChapter;
      }
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
                _buildImage(index),
                SizedBox(
                  width: 30,
                ),
                Column(
                  children: <Widget>[
                    Text("${info.name}"),
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

  void _add() async {
    setState(() {
      _loading = true;
    });

    if (_flag) {
      _flag = false;
      try {
        String net = _controller.text;
        BookInfo info = await GlobalInfo.chapterDao.parseBookFromNet(net);
        if (info.netPath == null) {
          _flag = true;
          return;
        }
        bool flag = await GlobalInfo.bookDao.saveBook(info, 1);
        setState(() {
          if (flag) books.add(info);
          _controller.text = "";
          _loading = false;
        });
        _flag = true;
      } catch (e) {
        _flag = true;
      }
    }
  }

  void _selectBtn(ShelfBtn shelfBtn) async {
    if (shelfBtn.btnName == "delete") {
      setState(() {
        books.remove(shelfBtn.info);
      });
      GlobalInfo.bookDao.delBook(shelfBtn.info);
    } else if (shelfBtn.btnName == "update") {
      setState(() {
        _loading = true;
      });

      var aBook =
          await GlobalInfo.chapterDao.parseBookFromNet(shelfBtn.info.netPath);
      if (aBook == null ||
          aBook.imgNetPath == null ||
          aBook.imgNetPath.isEmpty) {
        return;
      }
      aBook.lastReadChapter = shelfBtn.info.lastReadChapter;
      aBook.lastReadTime = shelfBtn.info.lastReadTime;
      aBook.id = shelfBtn.info.id;
      aBook.imgSavePath = shelfBtn.info.imgSavePath;
      setState(() {
        shelfBtn.info = aBook;
        _loading = false;
        books.sort((e1, e2) {
          if (e1.lastReadTime.isAfter(e2.lastReadTime)) {
            return -1;
          } else {
            return 1;
          }
        });
      });
      GlobalInfo.bookDao.saveBook(shelfBtn.info, 2);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  _buildImage(int index) {
    BookInfo info = this.books[index];

    if (info.imgSavePath != null && info.imgSavePath.isNotEmpty) {
      File file = File(info.imgSavePath);
      if (file.existsSync()) {
        return Image.file(
          file,
          height: 120,
          width: 70,
        );
      }
    }
    if (info.imgNetPath == null) {
      return Image.network(
        "",
        height: 120,
        width: 70,
      );
    }

    return Image.network(
      info.imgNetPath,
      height: 120,
      width: 70,
    );
  }

  Future<void> _onRefresh() async {
//    var list = await GlobalInfo.bookDao.loadBookShelf();
//    books.clear();
    setState(() {
      books.sort((e1, e2) {
        if (e1.lastReadTime.isAfter(e2.lastReadTime)) {
          return -1;
        } else {
          return 1;
        }
      });
    });
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
