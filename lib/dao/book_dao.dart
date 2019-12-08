import 'dart:io';

import 'package:book_reader/entity/book_chapter.dart';
import 'package:book_reader/entity/book_content.dart';
import 'package:book_reader/entity/book_info.dart';
import 'package:book_reader/parse/book_info_parse.dart';
import 'package:path_provider/path_provider.dart';

class BookDao {
  Directory _directory;

  BookParseFactory bookParseFactory = BookParseFactory();

  BookDao() {
    getExternalStorageDirectory().then((value) {
      _directory = value;
    });
  }

  Future<BookInfo> addBook(String url) async {
    return await bookParseFactory.parseBookInfo(url);
  }

  Future<BookContent> loadContent(Chapter chapter) async {
    if (_directory == null) {
      _directory = await getExternalStorageDirectory();
    }
    File file = File(_directory.path + chapter.savePath + ".txt");
    if (!file.existsSync()) {
      file.createSync(recursive: true);
      BookContent c =
          await bookParseFactory.parseChapterContent(chapter.netPath);
      file.writeAsString(c.content);
      return c;
    }
    return BookContent(await file.readAsString());
  }
}
