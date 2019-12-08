
import 'package:book_reader/entity/book_content.dart';
import 'package:book_reader/entity/book_info.dart';


import 'Bqg_prese.dart';

class BookParseFactory {
  static Map<String, BookParseInterface> _map = Map();

  void register(String path, BookParseInterface parse) {
    _map[path] = parse;
  }

  BookParseFactory() {
    BqgParse b = BqgParse();
    register(b.getUrlHead(), b);
  }

  Future<BookInfo> parseBookInfo(String url) async {
    var index = url.indexOf("/", 8);

    var p = _map[url.substring(0, index)];

    if (p == null) {
      return BookInfo();
    }
    return p.parseBook(url);
  }

  Future<BookContent> parseChapterContent(String url) async {
    var index = url.indexOf("/", 8);

    var p = _map[url.substring(0, index)];

    if (p == null) {
      return BookContent("");
    }
    return p.parseChapterContent(url);
  }
}

abstract class BookParseInterface {
  Future<BookInfo> parseBook(String url);

  String getUrlHead();

  Future<BookContent> parseChapterContent(String url);
}