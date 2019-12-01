class BookInfo {
  String bookName;

  String author;

  String savePath;

  String imgPath;

  String lastReadFile;

  DateTime lastReadTime;

  DateTime lastUpdateTime;

  int status;

  BookInfo();

  BookInfo.fromJson(Map<String, dynamic> map) {
    this.bookName = map["bookName"];
    this.author = map["author"];
    this.savePath = map["savePath"];
    this.imgPath = map["imgPath"];
    this.lastReadFile = map["lastReadFile"];
    this.lastReadTime = map["lastReadTime"];
    this.lastUpdateTime = map["lastUpdateTime"];
  }

  Map toJson() {
    Map map = new Map();
    map["bookName"] = this.bookName;
    map["author"] = this.author;
    map["savePath"] = this.savePath;
    map["imgPath"] = this.imgPath;
    map["lastReadFile"] = this.lastReadFile;
    map["lastReadTime"] = this.lastReadTime;
    map["lastUpdateTime"] = this.lastUpdateTime;
    return map;
  }
}
