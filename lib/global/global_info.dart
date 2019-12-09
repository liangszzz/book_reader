import 'package:book_reader/dao/book_dao.dart';
import 'package:book_reader/dao/book_shelf_dao.dart';
import 'package:book_reader/dao/log_dao.dart';
import 'package:book_reader/pages/book_shelf.dart';
import 'package:dio/dio.dart';

class GlobalInfo {
  static final String settingFile = "/setting.json";

  //APP 版本
  static final String version = "1.0.0";

  static final Duration duration = Duration(milliseconds: 100);

  static final BookShelfDao bookShelfDao = BookShelfDao();
  static final LogDao logDao = LogDao();

  static final Dio dioDao = Dio();

  static final BookDao bookDao = BookDao();

  static final BookShelf bookShelf = BookShelf();
}
