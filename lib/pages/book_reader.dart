import 'package:book_reader/entity/book_chapter.dart';
import 'package:book_reader/entity/book_content.dart';
import 'package:book_reader/entity/book_info.dart';
import 'package:book_reader/global/global_info.dart';
import 'package:book_reader/pages/book_chapters.dart';
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
          child: SingleChildScrollView(
            controller: _controller,
            child: Wrap(
              direction: Axis.horizontal,
              children: <Widget>[
                Text(
                  _content.content,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                )
              ],
            ),
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.only(left: 11, right: 10, bottom: 10),
          ),
        ),
      ),
      bottomNavigationBar: Builder(
        builder: (BuildContext buildContext) {
          return _buildBottomBar(buildContext);
        },
      ),
    );
  }

  void _onTap() {
    var height = MediaQuery.of(context).size.height;
    _controller.animateTo(_controller.position.pixels + height - 160,
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

    _saveReadInfo(chapter);
  }

  _buildBottomBar(context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.navigate_before),
          onPressed: () {
            _pre(context);
          },
        ),
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: _refresh,
        ),
        IconButton(
          icon: Icon(Icons.dehaze),
          onPressed: _showChapters,
        ),
        Expanded(
          child: SizedBox(),
        ),
        IconButton(
          icon: Icon(Icons.navigate_next),
          onPressed: () {
            _next(context);
          },
        )
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _pre(context) {
    if (_index == 0) {
      Scaffold.of(context).showSnackBar(new SnackBar(content: Text("已到最前")));
      return;
    } else {
      Chapter chapter = this.widget.bookInfo.chapters[--_index];
      _loadContent(chapter);
      _controller.animateTo(0,
          duration: GlobalInfo.duration, curve: Curves.ease);
    }
  }

  void _next(context) {
    if (this.widget.bookInfo.chapters.length <= _index + 1) {
      Scaffold.of(context).showSnackBar(new SnackBar(content: Text("已到最新")));
      return;
    } else {
      Chapter chapter = this.widget.bookInfo.chapters[++_index];
      _loadContent(chapter);
      _controller.animateTo(0,
          duration: GlobalInfo.duration, curve: Curves.ease);
    }
  }

  void _saveReadInfo(Chapter chapter) {
    if (chapter != null) this.widget.bookInfo.lastReadChapter = chapter;
    this.widget.bookInfo.lastReadTime = DateTime.now();
    GlobalInfo.bookShelf.save();
  }

  void _refresh() {
    Chapter chapter = this.widget.bookInfo.chapters[_index];
    _loadContent(chapter);
    _saveReadInfo(chapter);
    _controller.animateTo(0, duration: GlobalInfo.duration, curve: Curves.ease);
  }

  void _showChapters() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BookChapters(bookInfo: this.widget.bookInfo)),
    );
    if(result!=null){
      setState(() {
        _index = result;
        _loadContent(this.widget.bookInfo.chapters[result]);
      });
    }
  }
}
