import 'package:book_reader/entity/book_content.dart';
import 'package:book_reader/entity/book_info.dart';
import 'package:book_reader/global/global_info.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:book_reader/entity/book_chapter.dart';

import 'book_info_parse.dart';

class Bqg8Parse extends BookParseInterface {
  final String _url = "https://www.biquge.tw";

  @override
  String getUrlHead() => _url;

  @override
  Future<BookInfo> parseBook(String url) async {
    BookInfo info = BookInfo();

    Response response = await GlobalInfo.dioDao.get(url);
    var str = response.data;
    Document document = parse(str);

    Element bookName = document.querySelector("#info > h1");

    info.name = bookName.innerHtml;

    Element es = document.querySelector("#info > p");
    info.author = es.innerHtml.split("：")[1];

    info.lastUpdateTime = DateTime.now();
    Element desc = document.querySelector("#intro");
    info.desc = desc.innerHtml.replaceAll("<br>", "\\n");

    info.netPath = url;

    info.savePath = "/" + info.name + "/";

    Element imgPath = document.querySelector("#fmimg > img");
    info.imgNetPath = _url + imgPath.attributes['src'];

    info.chapters = List();

    List<Element> chapters = document.querySelectorAll("#list > dl >dd");

    for (int i = 0; i < chapters.length; i++) {
      if (i < 12) continue;
      Element element = chapters[i];
      Chapter chapter = Chapter();
      Node node = element.querySelector("a");
      chapter.index = i + 12;
      chapter.name = node.text;
      chapter.netPath = _url + "/" + node.attributes['href'];
      chapter.savePath = info.savePath + chapter.name;
      info.chapters.add(chapter);
    }

    info.lastReadChapter = 0;
    info.lastUpdateChapter = info.chapters.last.name;

    return info;
  }

  @override
  Future<BookContent> parseChapterContent(String url) async {
    Response response = await GlobalInfo.dioDao.get(url);
    var str = response.data;
    Document document = parse(str);
    Element content = document.querySelector("#content");
    var innerHtml = content.innerHtml;
    innerHtml = innerHtml
        .replaceAll("&nbsp;", " ")
        .replaceAll('<script type="text/javascript" src="', "")
        .replaceAll('/js/chaptererror.js"></script>', "")
        .replaceAll("<br>", "\n");
    return BookContent(innerHtml);
  }
}
