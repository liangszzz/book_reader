import 'package:book_reader/entity/book_chapter.dart';

final String tableBook = "book";
final String bookColumnId = '_id';
final String bookColumnName = 'name';
final String bookColumnAuthor = 'author';
final String bookColumnDesc = 'desc';
final String bookColumnSavePath = 'savePath';
final String bookColumnNetPath = 'netPath';
final String bookColumnImgPath = 'imgPath';
final String bookColumnLastReadChapter = 'lastReadChapter';
final String bookColumnLastReadTime = 'lastReadTime';
final String bookColumnLastUpdateTime = 'lastUpdateTime';
final String bookColumnLastUpdateChapter = 'lastUpdateChapter';

class BookInfo {
  int id;

  bool check = false;

  //书名
  String name;

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
  int lastReadChapter;

  DateTime lastReadTime;

  DateTime lastUpdateTime;

  //最新章节
  String lastUpdateChapter;

  //章节列表
  List<Chapter> chapters;

  BookInfo();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      bookColumnName: name,
      bookColumnAuthor: author,
      bookColumnDesc: desc,
      bookColumnSavePath: savePath,
      bookColumnNetPath: netPath,
      bookColumnImgPath: imgPath,
      bookColumnLastReadChapter: lastReadChapter,
      bookColumnLastReadTime:
          this.lastReadTime == null ? "" : this.lastReadTime.toIso8601String(),
      bookColumnLastUpdateTime: this.lastUpdateTime == null
          ? ""
          : this.lastUpdateTime.toIso8601String(),
      bookColumnLastUpdateChapter: lastUpdateChapter,
    };
    if (id != null) {
      map[bookColumnId] = id;
    }
    return map;
  }

  BookInfo.formMap(Map<String, dynamic> map) {
    this.id = map[bookColumnId];
    this.name = map[bookColumnName];
    this.author = map[bookColumnAuthor];
    this.desc = map[bookColumnDesc];
    this.savePath = map[bookColumnSavePath];
    this.netPath = map[bookColumnNetPath];
    this.imgPath = map[bookColumnImgPath];
    this.lastReadChapter = map[bookColumnLastReadChapter];

    if (map[bookColumnLastReadTime] != "") {
      this.lastReadTime = DateTime.parse(map[bookColumnLastReadTime]);
    }
    if (map[bookColumnLastUpdateTime] != "") {
      this.lastUpdateTime = DateTime.parse(map[bookColumnLastUpdateTime]);
    }
    this.lastUpdateChapter = map[bookColumnLastUpdateChapter];
  }
}
