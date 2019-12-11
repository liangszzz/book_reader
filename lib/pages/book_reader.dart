import 'package:book_reader/entity/book_chapter.dart';
import 'package:book_reader/entity/book_content.dart';
import 'package:book_reader/entity/book_info.dart';
import 'package:book_reader/global/global_info.dart';
import 'package:book_reader/pages/book_chapters.dart';
import 'package:book_reader/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  double _currentFontSize = 16.0;
  Color _currentTextColor = Colors.black;
  Color _currentBackGroundColor = Colors.white;

  void loadChapters() async {
    List<Chapter> loadChaptersByBook =
        await GlobalInfo.chapterDao.loadChaptersByBook(this.widget.bookInfo);
    this.widget.bookInfo.chapters = loadChaptersByBook;
    if (loadChaptersByBook == null || loadChaptersByBook.length == 0) return;
    _index = this.widget.bookInfo.lastReadChapter;
    setState(() {
      _loadContent(this.widget.bookInfo.chapters[_index]);
    });
  }

  @override
  void initState() {
    super.initState();
    loadSetting();
    loadChapters();
  }

  bool _loading = false;
  bool _showSetting = false;

  @override
  Widget build(BuildContext context) {
    _saveReadProcess(null);
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Stack(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(color: _currentBackGroundColor),
              alignment: Alignment.center,
              child: GestureDetector(
                  onTap: _onTap,
                  child: SingleChildScrollView(
                    controller: _controller,
                    child: _loading
                        ? Loading()
                        : Wrap(
                            direction: Axis.horizontal,
                            children: <Widget>[
                              Text(
                                _content.content,
                                style: TextStyle(
                                    color: _currentTextColor,
                                    fontSize: _currentFontSize),
                              )
                            ],
                          ),
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.only(left: 11, right: 10, bottom: 10),
                  ))),
          _showSetting ? _buildTextSetting() : SizedBox()
        ],
      ),
      bottomNavigationBar: Builder(
        builder: (BuildContext buildContext) {
          return _buildBottomBar(buildContext);
        },
      ),
    );
  }

  void _onTap() {
    if (_showSetting) {
      setState(() {
        _showSetting = false;
      });
      return;
    }
    var height = MediaQuery.of(context).size.height;
    _controller.animateTo(_controller.position.pixels + height - 160,
        duration: Duration(milliseconds: 10), curve: Curves.ease);
  }

  void _loadContent(Chapter chapter) async {
    setState(() {
      _loading = true;
    });
    var loadContent = GlobalInfo.chapterDao.loadContent(chapter);
    loadContent.then((value) {
      setState(() {
        _content = value;
        _title = chapter.name;
        _loading = false;
      });
    });

    _saveReadProcess(chapter);
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
        PopupMenuButton<String>(
          onSelected: _selectReadSetting,
          itemBuilder: (str) {
            return <PopupMenuItem<String>>[
              PopupMenuItem(
                value: "setting",
                child: Text("阅读设置"),
              ),
              PopupMenuItem(
                value: "reset",
                child: Text("默认设置"),
              )
            ];
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

  void _saveReadProcess(Chapter chapter) {
    if (chapter != null) this.widget.bookInfo.lastReadChapter = chapter.index;
    this.widget.bookInfo.lastReadTime = DateTime.now();
    GlobalInfo.bookDao.saveBook(this.widget.bookInfo, 3);
  }

  void _refresh() {
    Chapter chapter = this.widget.bookInfo.chapters[_index];
    _loadContent(chapter);
    setState(() {
      _loading = false;
    });
    _controller.animateTo(0, duration: GlobalInfo.duration, curve: Curves.ease);
  }

  void _showChapters() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BookChapters(bookInfo: this.widget.bookInfo)),
    );
    if (result != null) {
      setState(() {
        _index = result;
        _loadContent(this.widget.bookInfo.chapters[result]);
      });
    }
  }

  void loadSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("currentBackGroundColor")) {
      setState(() {
        _currentBackGroundColor = Color(prefs.getInt('currentBackGroundColor'));
        _currentTextColor = Color(prefs.getInt('currentTextColor'));
        _currentFontSize = prefs.getDouble('currentFontSize');
      });
    }
  }

  void _saveSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentBackGroundColor', _currentBackGroundColor.value);
    await prefs.setInt('currentTextColor', _currentTextColor.value);
    await prefs.setDouble('currentFontSize', _currentFontSize);
  }

  void _resetSetting() async {
    setState(() {
      _currentFontSize = 16.0;
      _currentTextColor = Colors.black;
      _currentBackGroundColor = Colors.white;
    });
  }

  _buildTextSetting() {
    return Center(
        child: Container(
      height: 150,
      decoration: BoxDecoration(color: Colors.blueGrey),
      child: Column(
        children: <Widget>[
          _buildTextColorSetting(),
          _buildBackGroundColorSetting(),
          Row(
            children: <Widget>[
              Text("文字大小"),
              Slider(
                  value: _currentFontSize,
                  min: 8,
                  max: 30,
                  divisions: 22,
                  label: "$_currentFontSize",
                  onChanged: (double val) {
                    setState(() {
                      _currentFontSize = val;
                    });
                    _saveSetting();
                  }),
            ],
          ),
        ],
      ),
    ));
  }

  _buildTextColorSetting() {
    return Expanded(
      child: ListView(scrollDirection: Axis.horizontal, children: <Widget>[
        Center(
          child: Text("文字颜色"),
        ),
        FlatButton(
          onPressed: () {
            setState(() {
              _currentTextColor = Colors.black;
            });
            _saveSetting();
          },
          child: Text(
            "黑色",
            style: TextStyle(color: Colors.black),
          ),
        ),
        FlatButton(
          onPressed: () {
            setState(() {
              _currentTextColor = Colors.white;
            });
            _saveSetting();
          },
          child: Text(
            "白色",
            style: TextStyle(color: Colors.white),
          ),
        ),
        FlatButton(
          onPressed: () {
            setState(() {
              _currentTextColor = Colors.red;
            });
            _saveSetting();
          },
          child: Text(
            "红色",
            style: TextStyle(color: Colors.red),
          ),
        ),
        FlatButton(
          onPressed: () {
            setState(() {
              _currentTextColor = Colors.blue;
            });
            _saveSetting();
          },
          child: Text(
            "蓝色",
            style: TextStyle(color: Colors.blue),
          ),
        ),
        FlatButton(
          onPressed: () {
            setState(() {
              _currentTextColor = Colors.grey;
            });
            _saveSetting();
          },
          child: Text(
            "灰色",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        FlatButton(
          onPressed: () {
            setState(() {
              _currentTextColor = Colors.green;
            });
            _saveSetting();
          },
          child: Text(
            "绿色",
            style: TextStyle(color: Colors.green),
          ),
        ),
        FlatButton(
          onPressed: () {
            setState(() {
              _currentTextColor = Colors.brown;
            });
            _saveSetting();
          },
          child: Text(
            "棕色",
            style: TextStyle(color: Colors.brown),
          ),
        )
      ]),
    );
  }

  _buildBackGroundColorSetting() {
    return Expanded(
      child: ListView(scrollDirection: Axis.horizontal, children: <Widget>[
        Center(
          child: Text("背景颜色"),
        ),
        FlatButton(
          onPressed: () {
            setState(() {
              _currentBackGroundColor = Colors.black;
            });
            _saveSetting();
          },
          child: Text(
            "黑色",
            style: TextStyle(color: Colors.black),
          ),
        ),
        FlatButton(
          onPressed: () {
            setState(() {
              _currentBackGroundColor = Colors.white;
            });
            _saveSetting();
          },
          child: Text(
            "白色",
            style: TextStyle(color: Colors.white),
          ),
        ),
        FlatButton(
          onPressed: () {
            setState(() {
              _currentBackGroundColor = Colors.red;
            });
            _saveSetting();
          },
          child: Text(
            "红色",
            style: TextStyle(color: Colors.red),
          ),
        ),
        FlatButton(
          onPressed: () {
            setState(() {
              _currentBackGroundColor = Colors.blue;
            });
            _saveSetting();
          },
          child: Text(
            "蓝色",
            style: TextStyle(color: Colors.blue),
          ),
        ),
        FlatButton(
          onPressed: () {
            setState(() {
              _currentBackGroundColor = Colors.grey;
            });
            _saveSetting();
          },
          child: Text(
            "灰色",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        FlatButton(
          onPressed: () {
            setState(() {
              _currentBackGroundColor = Colors.green;
            });
            _saveSetting();
          },
          child: Text(
            "绿色",
            style: TextStyle(color: Colors.green),
          ),
        ),
        FlatButton(
          onPressed: () {
            setState(() {
              _currentBackGroundColor = Colors.brown;
            });
            _saveSetting();
          },
          child: Text(
            "棕色",
            style: TextStyle(color: Colors.brown),
          ),
        )
      ]),
    );
  }

  void _selectReadSetting(String value) {
    switch (value) {
      case "setting":
        setState(() {
          _showSetting = true;
        });
        break;
      case "reset":
        _resetSetting();
        _saveSetting();
        break;
    }
  }
}
