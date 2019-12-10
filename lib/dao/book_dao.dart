import 'dart:io';

import 'package:book_reader/entity/book_chapter.dart';
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

  Future<bool> saveBook(BookInfo bookInfo) async {
    Database _database = await GlobalInfo.dbDao.getConnection();
    var count = Sqflite.firstIntValue(await _database.rawQuery(
        "select count(*) from $tableBook where $bookColumnName='${bookInfo.name}'"));
    if (count == 0) {
      bookInfo.id = await _database.insert(tableBook, bookInfo.toMap());
      GlobalInfo.chapterDao.saveBookChapters(bookInfo);
      return true;
    } else {
      _database.update(tableBook, bookInfo.toMap(),
          where: "$bookColumnId=? or $bookColumnName=?",
          whereArgs: [bookInfo.id, bookInfo.name]);
      return false;
    }
  }

  void delBook(BookInfo bookInfo) async {
    var _database = await GlobalInfo.dbDao.getConnection();
    await _database
        .delete(tableBook, where: "$bookColumnId=?", whereArgs: [bookInfo.id]);
    await _database.delete(tableChapter,
        where: "$chapterColumnBookId=?", whereArgs: [bookInfo.id]);
    File file = File(await GlobalInfo.dbDao.getFilePath() + bookInfo.savePath);
    if (file.existsSync()) await file.delete(recursive: true);
  }

  void updateBook(BookInfo bookInfo) async{
    Database _database = await GlobalInfo.dbDao.getConnection();
    var count = Sqflite.firstIntValue(await _database.rawQuery(
    "select count(*) from $tableBook where $bookColumnName='${bookInfo.name}'"));
    if (count == 0) {
      return;
    }
    else{
      _database.update(tableBook, bookInfo.toMap(),
          where: "$bookColumnId=? or $bookColumnName=?",
          whereArgs: [bookInfo.id, bookInfo.name]);
      GlobalInfo.chapterDao.saveBookChapters(bookInfo);
    }
  }
}
