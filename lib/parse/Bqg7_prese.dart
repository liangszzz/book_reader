import 'package:book_reader/entity/book_content.dart';
import 'package:book_reader/entity/book_info.dart';
import 'package:book_reader/global/global_info.dart';
import 'package:gbk2utf8/gbk2utf8.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:book_reader/entity/book_chapter.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'book_info_parse.dart';

class Bqg7Parse extends BookParseInterface {
  final String _url = "https://www.biqugemm.com";

  @override
  String getUrlHead() => _url;

  @override
  Future<BookInfo> parseBook(String url) async {
    BookInfo info = BookInfo();

    http.Response response = await http.get(url);
    String data = gbk.decode(response.bodyBytes);

    Document document = parse(data);

    Element bookName = document.querySelector("#info > h1");

    info.name = bookName.innerHtml;

    List<Element> es = document.querySelectorAll("#info > p");

    for (int i = 0; i < es.length; i++) {
      if (i == 0) info.author = es[i].innerHtml.split("：")[1];
      if (i == 2) {
        var t1 = es[i].innerHtml;
        var indexOf = t1.indexOf("：");
        info.lastUpdateTime = DateTime.parse(t1.substring(indexOf + 1));
      }
    }
    Element desc = document.querySelector("#intro > p");
    info.desc =
        desc.innerHtml.replaceAll("<br>", "\\n").replaceAll("&nbsp;", " ");

    info.netPath = url;

    info.savePath = "/" + info.name + "/";

    Element imgPath = document.querySelector("#fmimg > img");
    if (imgPath == null) {
      info.imgNetPath =GlobalInfo.defaultImgNetPath;
    }
    else{
      info.imgNetPath = _url + imgPath.attributes['src'];
    }

    info.chapters = List();

    List<Element> chapters = document.querySelectorAll("#list > dl > dd");

    for (int i = 0; i < chapters.length; i++) {
      Element element = chapters[i];
      Chapter chapter = Chapter();
      Node node = element.querySelector("a");
      chapter.index = i;
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
        .replaceAll("&nbsp;", " ")
        .replaceAll("一秒记住【笔趣阁MM", "")
        .replaceAll("】，精彩小说无弹窗免费阅读！", "")
        .replaceAll(
            '<a href="https://www.biqugemm.com" target="_blank">www.biqugemm.com</a>',
            "")
        .replaceAll("<br>", "\n");
    return BookContent(innerHtml);
  }
}
