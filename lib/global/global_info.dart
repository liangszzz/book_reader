import 'package:book_reader/dao/chapter_dao.dart';
import 'package:book_reader/dao/book_dao.dart';
import 'package:book_reader/dao/db_dao.dart';
import 'package:book_reader/dao/log_dao.dart';
import 'package:book_reader/parse/book_info_parse.dart';
import 'package:dio/dio.dart';

class GlobalInfo {
  static final String settingFile = "/setting.json";

  //APP 版本
  static final String version = "1.0.0";

  static final Duration duration = Duration(milliseconds: 100);

  static final BookShelfDao bookDao = BookShelfDao();

  static final LogDao logDao = LogDao();

  static final Dio dioDao = Dio();

  static final ChapterDao chapterDao = ChapterDao();

  static final DBDao dbDao = DBDao();

  static final BookParseFactory bookParseFactory = BookParseFactory();
}
