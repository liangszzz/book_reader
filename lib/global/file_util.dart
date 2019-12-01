import 'dart:io';
import 'dart:convert';

import 'package:book_reader/global/global_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:book_reader/entity/book_info.dart';

class FileUtil {
  static Future<List<BookInfo>> getBooksFromFile() async {
    Directory directory = await getExternalStorageDirectory();
    File file = new File(directory.path + "/shelf.json");
    file.createSync();
    String content = file.readAsStringSync();
    List<BookInfo> list;
    try {
      list = jsonDecode(content);
    } catch (e) {
      list = List();
      saveLogToFile(e.toString());
    }
    return list;
  }

  static void saveBookShelfToFile() async {
    Directory directory = await getExternalStorageDirectory();
    File file = new File(directory.path + "/shelf.json");
    file.writeAsStringSync(jsonEncode(GlobalInfo.bookShelf));
  }

  static void saveLogToFile(String exception) async {
    print("###error###" + exception);
    Directory directory = await getExternalStorageDirectory();
    File file = new File(directory.path + "/log.log");
    var randomAccessFile = await file.open(mode: FileMode.writeOnlyAppend);
    randomAccessFile.writeString(exception + "\n");
  }
}
