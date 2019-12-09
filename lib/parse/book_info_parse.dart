import 'package:book_reader/entity/book_content.dart';
import 'package:book_reader/entity/book_info.dart';

import 'Bqg2_prese.dart';
import 'Bqg3_prese.dart';
import 'Bqg4_prese.dart';
import 'Bqg5_prese.dart';
import 'Bqg_prese.dart';

class BookParseFactory {
  static Map<String, BookParseInterface> _map = Map();

  void register(String path, BookParseInterface parse) {
    _map[path] = parse;
  }

  BookParseFactory() {
    BqgParse b = BqgParse();
    register(b.getUrlHead(), b);

    Bqg2Parse b2 = Bqg2Parse();
    register(b2.getUrlHead(), b2);

    Bqg3Parse b3 = Bqg3Parse();
    register(b3.getUrlHead(), b3);

    Bqg4Parse b4 = Bqg4Parse();
    register(b4.getUrlHead(), b4);

    Bqg5Parse b5 = Bqg5Parse();
    register(b5.getUrlHead(), b5);
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
