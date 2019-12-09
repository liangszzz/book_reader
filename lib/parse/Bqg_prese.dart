import 'package:book_reader/entity/book_content.dart';
import 'package:book_reader/entity/book_info.dart';
import 'package:book_reader/global/global_info.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:book_reader/entity/book_chapter.dart';

import 'book_info_parse.dart';

class BqgParse extends BookParseInterface {
  @override
  String getUrlHead() => "https://www.biquge.info";

  @override
  Future<BookInfo> parseBook(String url) async {
    BookInfo info = BookInfo();

    Response response = await GlobalInfo.dioDao.get(url);
    var str = response.data;
    Document document = parse(str);

    Element bookName = document.querySelector("#info > h1");

    info.name = bookName.innerHtml;

    List<Element> es = document.querySelectorAll("#info > p");

    for (int i = 0; i < es.length; i++) {
      if (i == 0) info.author = es[i].innerHtml.split(":")[1];
      if (i == 2) {
        var t1 = es[i].innerHtml;
        var indexOf = t1.indexOf(":");
        info.lastUpdateTime = DateTime.parse(t1.substring(indexOf + 1));
      }
    }
    Element desc = document.querySelector("#intro");
    info.desc = desc.innerHtml
        .replaceAll("<p>", "")
        .replaceAll("<//p>", "")
        .replaceAll("//n", "")
        .replaceAll("<br>", "");

    info.netPath = url;

    info.savePath = "/" + info.name + "/";

    Element imgPath = document.querySelector("#fmimg > img");
    info.imgPath = imgPath.attributes['src'];

    info.chapters = List();

    Element chapters = document.querySelector("#list > dl");

    for (int i = 0; i < chapters.children.length; i++) {
      Element element = chapters.children[i];
      Chapter chapter = Chapter();
      Node node = element.firstChild;

      chapter.index = i;
      chapter.name = node.attributes['title'];
      chapter.netPath = url + "/" + node.attributes['href'];
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
        .replaceAll("<!--over-->", "")
        .replaceAll("<!--go-->", "")
        .replaceAll("<br>", "\n");
    return BookContent(innerHtml);
  }
}
