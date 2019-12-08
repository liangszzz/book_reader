import 'dart:convert';

import 'package:book_reader/entity/book_chapter.dart';

class BookInfo {
  bool check = false;

  //书名
  String bookName;

  //作者
  String author;

  //描述
  String desc;

  //文件存储位置
  String savePath;

  //书籍来源地址
  String netPath;

  //封面地址
  String imgPath;

  //最后阅读中章节名称
  Chapter lastReadChapter;

  DateTime lastReadTime;

  DateTime lastUpdateTime;

  //最新章节
  Chapter lastChapter;

  //章节列表
  List<Chapter> chapters;

  BookInfo();

  BookInfo.fromJson(Map<String, dynamic> map) {
    this.bookName = map["bookName"];
    this.author = map["author"];
    this.desc = map["desc"];

    this.savePath = map["savePath"];
    this.netPath = map["netPath"];
    this.imgPath = map["imgPath"];

    var lastReadChapter = jsonDecode(map["lastReadChapter"]);

    this.lastReadChapter = Chapter.fromJson(lastReadChapter);

    if (!(map["lastReadTime"] == "")) {
      this.lastReadTime = DateTime.parse(map["lastReadTime"]);
    }
    if (!(map["lastUpdateTime"] == "")) {
      this.lastUpdateTime = DateTime.parse(map["lastUpdateTime"]);
    }

    var lastChapter = jsonDecode(map["lastChapter"]);

    this.lastChapter = Chapter.fromJson(lastChapter);

    List<dynamic> cs = jsonDecode(map['chapters']);

    this.chapters = cs.map((f) => Chapter.fromJson(f)).toList();
  }

  Map toJson() {
    Map map = new Map();

    map["bookName"] = this.bookName;
    map["author"] = this.author;
    map["desc"] = this.desc;

    map["savePath"] = this.savePath;
    map["netPath"] = this.netPath;
    map["imgPath"] = this.imgPath;
    map["lastReadChapter"] = jsonEncode(this.lastReadChapter);
    map["lastReadTime"] =
        this.lastReadTime == null ? "" : this.lastReadTime.toIso8601String();
    map["lastUpdateTime"] = this.lastUpdateTime == null
        ? ""
        : this.lastUpdateTime.toIso8601String();
    map["lastChapter"] = jsonEncode(this.lastChapter);
    map["chapters"] = jsonEncode(this.chapters);

    return map;
  }
}
