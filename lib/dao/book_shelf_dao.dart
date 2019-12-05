import 'dart:convert';
import 'dart:io';

import 'package:book_reader/dao/log_dao.dart';
import 'package:book_reader/entity/book_info.dart';
import 'package:book_reader/global/global_info.dart';

class BookShelfDao {
  static Future<List<BookInfo>> loadBookShelf() async {
    File file =
        File(await GlobalInfo.getDirectory() + GlobalInfo.appSetting.shelfFile);
    if (file.existsSync()) {
      String content = file.readAsStringSync();
      List<BookInfo> list;
      try {
        List<BookInfo> infos = new List();
        List<dynamic> convert = jsonDecode(content);
        convert.forEach((e) {
          BookInfo info = BookInfo.fromJson(e);
          infos.add(info);
        });
        list = infos;
      } catch (e) {
        list = List();
        LogDao.saveLogToFile(e.toString());
      }
      return list;
    } else {
      file.createSync(recursive: true);
      return List<BookInfo>();
    }
  }

  static void saveBookShelfToFile(List<BookInfo> list) async {
    GlobalInfo.getDirectory().then((value) {
      File file = File(value + GlobalInfo.appSetting.shelfFile);
      file.writeAsStringSync(jsonEncode(list));
    });
  }
}
