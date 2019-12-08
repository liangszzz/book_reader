import 'dart:convert';
import 'dart:io';

import 'package:book_reader/entity/book_chapter.dart';
import 'package:book_reader/entity/book_info.dart';
import 'package:book_reader/global/global_info.dart';
import 'package:path_provider/path_provider.dart';

class BookShelfDao {
  String _shelfFile = "/shelf.txt";

  Directory _directory;

  List<BookInfo> books = List();

  BookShelfDao() {
    getExternalStorageDirectory().then((value) {
      _directory = value;
      _loadBookShelf();
    });
  }

  void _loadBookShelf() async {
    File file = File(_directory.path + _shelfFile);

    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }

    String content = file.readAsStringSync();
    try {
      List<dynamic> convert = jsonDecode(content);
      convert.forEach((e) {
        BookInfo info = BookInfo.fromJson(e);
        books.add(info);
      });
    } catch (e) {
      GlobalInfo.logDao.saveLogToFile(e.toString());
    }
  }

  void addBook(BookInfo bookInfo) {
    books.add(bookInfo);
    _saveBookShelfToFile();
  }

  void delBook(BookInfo bookInfo) {
    books.remove(bookInfo);
    _saveBookShelfToFile();
  }

  void _saveBookShelfToFile() async {
    File file = File(_directory.path + _shelfFile);
    var json = jsonEncode(books);
    file.writeAsStringSync(json);
  }

  void saveReadProcess(BookInfo bookInfo, Chapter chapter) {
    var book = GlobalInfo.bookShelfDao.books.firstWhere((e) {
      return e.bookName == bookInfo.bookName;
    });
    if (chapter != null) {
      book.lastReadChapter = chapter;
    }
    book.lastReadTime = DateTime.now();
    _saveBookShelfToFile();
  }
}
