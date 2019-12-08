import 'package:book_reader/entity/book_chapter.dart';
import 'package:book_reader/entity/book_content.dart';
import 'package:book_reader/entity/book_info.dart';
import 'package:book_reader/global/global_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BookReader extends StatefulWidget {
  final BookInfo bookInfo;

  const BookReader({Key key, this.bookInfo}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BookReaderState();
}

class _BookReaderState extends State<BookReader> {
  BookContent _content = BookContent("");

  String _title = "";

  ScrollController _controller = new ScrollController();

  int _index = 0;

  @override
  void initState() {
    super.initState();

    _index = this.widget.bookInfo.chapters.indexWhere((e) {
      return e.name == this.widget.bookInfo.lastReadChapter.name;
    });

    setState(() {
      _loadContent(this.widget.bookInfo.lastReadChapter);
    });
  }

  @override
  Widget build(BuildContext context) {
    _saveReadInfo(null);
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Container(
        child: GestureDetector(
          onTap: _onTap,
          child: ListView.builder(
            controller: _controller,
            itemBuilder: (context, i) {
              return Wrap(
                children: <Widget>[Text(_content.content)],
              );
            },
            itemCount: 1,
            scrollDirection: Axis.vertical,
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  void _onTap() {
    var height = MediaQuery.of(context).size.height;
    _controller.animateTo(_controller.position.pixels + height-160,
        duration: Duration(milliseconds: 10), curve: Curves.ease);
  }

  void _loadContent(Chapter chapter) {
    var loadContent = GlobalInfo.bookDao.loadContent(chapter);
    loadContent.then((value) {
      setState(() {
        _content = value;
        _title = chapter.name;
      });
    });
  }

  _buildBottomBar() {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.navigate_before),
          onPressed: _pre,
        ),
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: _refresh,
        ),
        Expanded(
          child: SizedBox(),
        ),
        IconButton(
          icon: Icon(Icons.navigate_next),
          onPressed: _next,
        )
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _pre() {
    if (_index == 0) {
      return;
    } else {
      Chapter chapter = this.widget.bookInfo.chapters[--_index];
      _loadContent(chapter);
      _saveReadInfo(chapter);
      _controller.animateTo(0,
          duration: GlobalInfo.duration, curve: Curves.ease);
    }
  }

  void _next() {
    if (this.widget.bookInfo.chapters.length <= _index) {
      return;
    } else {
      Chapter chapter = this.widget.bookInfo.chapters[++_index];
      _loadContent(chapter);
      _saveReadInfo(chapter);
      _controller.animateTo(0,
          duration: GlobalInfo.duration, curve: Curves.ease);
    }
  }

  void _saveReadInfo(Chapter chapter) {
    GlobalInfo.bookShelfDao.saveReadProcess(this.widget.bookInfo, chapter);
  }

  void _refresh() {
    Chapter chapter = this.widget.bookInfo.chapters[_index];
    _loadContent(chapter);
    _saveReadInfo(chapter);
    _controller.animateTo(0,
            duration: GlobalInfo.duration, curve: Curves.ease);
  }
}
