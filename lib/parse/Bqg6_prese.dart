import 'package:book_reader/entity/book_content.dart';
import 'package:book_reader/entity/book_info.dart';
import 'package:gbk2utf8/gbk2utf8.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:book_reader/entity/book_chapter.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'book_info_parse.dart';

class Bqg6Parse extends BookParseInterface {

  final String _url = "https://www.biqukan.com";

  @override
  String getUrlHead() => _url;

  @override
  Future<BookInfo> parseBook(String url) async {
    BookInfo info = BookInfo();

    http.Response response = await http.get(url);
    String data = gbk.decode(response.bodyBytes);

    Document document = parse(data);

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
    Element desc = document.querySelector(".intro");
    info.desc = desc.innerHtml
        .replaceAll("<span>简介：<\/span>", "")
        .replaceAll("${info.author}所写的《${info.name}》", "")
        .replaceAll("无弹窗免费全文阅读为转载作品,章节由网友发布。", "")
        .replaceAll("无弹窗推荐地址：", "")
        .replaceAll("${info.netPath}", "");

    info.netPath = url;

    info.savePath = "/" + info.name + "/";

    Element imgPath =
        document.querySelector("body > div.book > div.info > div.cover > img");
    info.imgNetPath = _url + imgPath.attributes['src'];

    info.chapters = List();

    List<Element> chapters =
        document.querySelectorAll("body > div.listmain > dl > dd");

    for (int i = 0; i < chapters.length; i++) {
      if (i < 12) continue;
      Element element = chapters[i];
      Chapter chapter = Chapter();
      Node node = element.querySelector("a");
      chapter.index = i - 12;
      chapter.name = node.text;
      chapter.netPath = _url + node.attributes['href'];
      chapter.savePath = info.savePath + chapter.name;
      info.chapters.add(chapter);
    }

    info.lastReadChapter = 0;
    info.lastUpdateChapter = info.chapters.last.name;

    return info;
  }

  @override
  Future<BookContent> parseChapterContent(String url) async {
    http.Response response = await http.get(url);
    String data = gbk.decode(response.bodyBytes);

    Document document = parse(data);

    Element content = document.querySelector("#content");
    var innerHtml = content.innerHtml;
    innerHtml = innerHtml
        .replaceAll("<script>", "")
        .replaceAll("</script>", "")
        .replaceAll("app2();", "")
        .replaceAll("chaptererror();", "")
        .replaceAll("($url)", "")
        .replaceAll("请记住本书首发域名：www.biqukan.com。笔趣阁手机版阅读网址：wap.biqukan.com", "")
        .replaceAll("<br>", "\n");
    return BookContent(innerHtml);
  }
}
