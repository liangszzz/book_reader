import 'package:book_reader/entity/book_chapter.dart';
import 'package:book_reader/entity/book_info.dart';
import 'package:book_reader/global/global_info.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class BookParseFactory {
  static Map<String, _BookParse> _map = Map();

  void register(String path, _BookParse parse) {
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
}

abstract class _BookParse {
  Future<BookInfo> parseBook(url);

  String getUrlHead();
}

class BqgParse extends _BookParse {
  @override
  Future<BookInfo> parseBook(url) async {
    BookInfo info = BookInfo();

    Response response = await GlobalInfo.dioDao.get(url);
    var str = response.data;
    Document document = parse(str);

    Element bookName = document.querySelector("#info > h1");

    info.bookName = bookName.innerHtml;

    List<Element> es = document.querySelectorAll("#info > p");

    for (int i = 0; i < es.length; i++) {
      if (i == 0) info.author = es[i].innerHtml.split(":")[1];
      if (i == 2) {
        var t1 = es[i].innerHtml;
        var indexOf = t1.indexOf(":");
        info.lastUpdateTime = DateTime.parse(t1.substring(indexOf + 1));
      }
    }

    Element lastChapter = document.querySelector("#info > p > a");
    info.lastChapter = lastChapter.innerHtml;

    Element desc = document.querySelector("#intro");
    info.desc = desc.innerHtml
        .replaceAll("<p>", "")
        .replaceAll("<//p>", "")
        .replaceAll("//n", "")
        .replaceAll("<br>", "");

    info.netPath = url;

    info.savePath = "/" + info.bookName + "/";

    Element imgPath = document.querySelector("#fmimg > img");
    info.imgPath = imgPath.attributes['src'];

    info.chapters = List();

    Element chapters = document.querySelector("#list > dl");

    chapters.children.forEach((Element element) {
      Chapter chapter = Chapter();

      Node node = element.firstChild;

      chapter.name = node.attributes['title'];
      chapter.netPath = url + node.attributes['href'];
      chapter.savePath = info.savePath + chapter.name;

      info.chapters.add(chapter);
    });

    info.lastReadChapterName = info.chapters[0].name;

    return info;
  }

  @override
  String getUrlHead() {
    return "https://www.biquge.info";
  }
}
