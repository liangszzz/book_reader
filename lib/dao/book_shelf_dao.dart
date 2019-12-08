import 'dart:convert';
import 'dart:io';

import 'package:book_reader/entity/book_info.dart';
import 'package:book_reader/global/global_info.dart';
import 'package:path_provider/path_provider.dart';

class BookShelfDao {
  String _shelfFile = "/shelf.txt";

  Directory _directory;

  BookShelfDao() {
    getExternalStorageDirectory().then((value) {
      _directory = value;
    });
  }

  Future<List<BookInfo>> loadBookShelf() async {
    if (_directory == null) {
      _directory = await getExternalStorageDirectory();
    }

    File file = File(_directory.path + _shelfFile);

    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    List<BookInfo> list = List();

    String content = file.readAsStringSync();
    try {
      List<dynamic> convert = jsonDecode(content);
      convert.forEach((e) {
        BookInfo info = BookInfo.fromJson(e);
        list.add(info);
      });
    } catch (e) {
      GlobalInfo.logDao.saveLogToFile(e.toString());
    }
    return list;
  }

  void saveBookShelfToFile(List<BookInfo> books) async {
    if (books == null || books.length == 0) return;
    File file = File(_directory.path + _shelfFile);
    var json = jsonEncode(books);
    file.writeAsStringSync(json);
  }

  void delBookFile(BookInfo bookInfo) {
    File file = File(_directory.path + bookInfo.savePath);
    file.delete(recursive: true);
  }
}
