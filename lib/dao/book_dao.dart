import 'dart:io';

import 'package:book_reader/entity/book_info.dart';
import 'package:book_reader/global/global_info.dart';
import 'package:sqflite/sqflite.dart';

class BookShelfDao {
  BookShelfDao();

  Future<List<BookInfo>> loadBookShelf() async {
    var _database = await GlobalInfo.dbDao.getConnection();
    List<Map<String, dynamic>> query = await _database.query(tableBook);
    return query.map((e) {
      BookInfo bookInfo = BookInfo.formMap(e);
      return bookInfo;
    }).toList();
  }

  saveBook(BookInfo bookInfo) async {
    Database _database = await GlobalInfo.dbDao.getConnection();
    var count = Sqflite.firstIntValue(await _database
        .rawQuery("select count(*) from book where name='${bookInfo.name}'"));
    if (count == 0) {
      bookInfo.id = await _database.insert(tableBook, bookInfo.toMap());
    } else {
      _database.update(tableBook, bookInfo.toMap());
    }
  }

  void delBook(BookInfo bookInfo) async {
    var _database = await GlobalInfo.dbDao.getConnection();
    await _database.transaction((tx) async {
      await _database
          .delete(tableBook, where: "id=?", whereArgs: [bookInfo.id]);
    });
    File file = File(await GlobalInfo.dbDao.getFilePath() + bookInfo.savePath);
    await file.delete(recursive: true);
  }
}
