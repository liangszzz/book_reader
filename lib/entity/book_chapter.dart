final String tableChapter = "chapter";
final String chapterColumnId = '_id';
final String chapterColumnIndex = 'index';
final String chapterColumnBookId = 'bookId';
final String chapterColumnName = 'name';
final String chapterColumnNetPath = 'netPath';
final String chapterColumnSavePath = 'savePath';

class Chapter {
  int id;

  int index;

  int bookId;

  String name;

  String netPath;

  String savePath;

  Chapter();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map();
    map[chapterColumnIndex] = this.index;
    map[chapterColumnBookId] = this.bookId;
    map[chapterColumnName] = this.name;
    map[chapterColumnNetPath] = this.netPath;
    map[chapterColumnSavePath] = this.savePath;
    if (id != null) {
      map[chapterColumnId] = id;
    }
    return map;
  }

  Chapter.formMap(Map<String, dynamic> map) {
    this.id = map[chapterColumnId];
    this.index = map[chapterColumnIndex];
    this.bookId = map[chapterColumnBookId];
    this.name = map[chapterColumnName];
    this.savePath = map[chapterColumnSavePath];
    this.netPath = map[chapterColumnNetPath];
  }
}
