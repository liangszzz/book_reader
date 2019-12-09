import 'package:book_reader/entity/book_content.dart';
import 'package:book_reader/entity/book_info.dart';
import 'package:book_reader/global/global_info.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:book_reader/entity/book_chapter.dart';
import 'package:html/parser.dart';

import 'book_info_parse.dart';

class Bqg6Parse extends BookParseInterface {
  @override
  String getUrlHead() => "https://www.biqukan.com";

  @override
  Future<BookInfo> parseBook(String url) async {
    BookInfo info = BookInfo();

    Response response = await GlobalInfo.dioDao.get(url);
    var str = response.data;

    Document document = parse(str,encoding: "gbk");

    Element bookName =
        document.querySelector("body > div.book > div.info > h2");

    info.name = bookName.innerHtml;

    List<Element> es = document
        .querySelectorAll("body > div.book > div.info > div.small > span");

    for (int i = 0; i < es.length; i++) {
      if (i == 0) info.author = es[i].innerHtml.split("：")[1];
      if (i == 4) {
        var t1 = es[i].innerHtml;
        var indexOf = t1.indexOf("：");
        info.lastUpdateTime = DateTime.parse(t1.substring(indexOf + 1));
      }
    }
    Element desc = document.querySelector("#intro");
    info.desc = desc.innerHtml
        .replaceAll("<br>", "\\n")
        .replaceAll("无弹窗推荐地址：https://www.biqukan.com/72_72564/", "");

    info.netPath = url;

    info.savePath = "/" + info.name + "/";

    Element imgPath = document.querySelector("body > div.book > div.info > div.cover > img");
    info.imgPath = getUrlHead() + imgPath.attributes['src'];

    info.chapters = List();

    List<Element> chapters = document.querySelectorAll("body > div.listmain > dl > dd");

    for (int i = 0; i < chapters.length; i++) {
      if (i < 12) continue;
      Element element = chapters[i];
      Chapter chapter = Chapter();
      Node node = element.querySelector("a");
      chapter.index = i - 12;
      chapter.name = node.text;
      chapter.netPath = getUrlHead() + node.attributes['href'];
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
        .replaceAll("\n;", " ")
        .replaceAll("\t;", " ")
        .replaceAll("<script>", "")
        .replaceAll("</script>", "")
        .replaceAll("app2();", "")
        .replaceAll("read3();", "")
        .replaceAll("<br>", "\n");
    return BookContent(innerHtml);
  }
}
