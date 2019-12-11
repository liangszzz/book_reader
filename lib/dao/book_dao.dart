import 'dart:io';

import 'package:book_reader/entity/book_chapter.dart';
import 'package:book_reader/entity/book_info.dart';
import 'package:book_reader/global/global_info.dart';
import 'package:sqflite/sqflite.dart';

class BookShelfDao {
  BookShelfDao();

  Future<List<BookInfo>> loadBookShelf() async {
    var _database = await GlobalInfo.dbDao.getConnection();
    List<Map<String, dynamic>> query = await _database.query(tableBook,
        orderBy: "$bookColumnLastReadTime desc");
    return query.map((e) {
      BookInfo bookInfo = BookInfo.formMap(e);
      return bookInfo;
    }).toList();
  }

  ///    保存书籍信息
  ///    [bookInfo] 书籍
  ///    [flag] 1 新增,2更新,3保存阅读进度
  Future<bool> saveBook(BookInfo bookInfo, int flag) async {
    Database _database = await GlobalInfo.dbDao.getConnection();
    var count = Sqflite.firstIntValue(await _database.rawQuery(
        "select count(*) from $tableBook where $bookColumnName='${bookInfo.name}'"));

    switch (flag) {
      case 1:
        //添加
        if (count > 0) return false;
        if (bookInfo.imgNetPath != null && bookInfo.imgNetPath.isNotEmpty) {
          bookInfo.imgSavePath = await GlobalInfo.dbDao.getImagePath() +
              "/" +
              bookInfo.name +
              bookInfo.imgNetPath
                  .substring(bookInfo.imgNetPath.lastIndexOf("."));
          GlobalInfo.dioDao.download(bookInfo.imgNetPath, bookInfo.imgSavePath);
        }
        bookInfo.id = await _database.insert(tableBook, bookInfo.toMap());
        GlobalInfo.chapterDao.saveBookChapters(bookInfo);
        break;
      case 2:
        //书籍更新
        if (count == 0) return false;
        if (bookInfo.imgNetPath != null && bookInfo.imgNetPath.isNotEmpty) {
          bookInfo.imgSavePath = await GlobalInfo.dbDao.getImagePath() +
              "/" +
              bookInfo.name +
              bookInfo.imgNetPath
                  .substring(bookInfo.imgNetPath.lastIndexOf("."));
          File file = File(bookInfo.imgSavePath);
          if (!file.existsSync()) {
            GlobalInfo.dioDao
                .download(bookInfo.imgNetPath, bookInfo.imgSavePath);
          }
        }
        _database.update(tableBook, bookInfo.toMap(),
            where: "$bookColumnId=? or $bookColumnName=?",
            whereArgs: [bookInfo.id, bookInfo.name]);
        GlobalInfo.chapterDao.saveBookChapters(bookInfo);
        break;
      case 3:
        //保存阅读进度
        if (count == 0) return false;
        _database.update(tableBook, bookInfo.toMap(),
            where: "$bookColumnId=? or $bookColumnName=?",
            whereArgs: [bookInfo.id, bookInfo.name]);
        break;
    }
    return true;
  }

  void delBook(BookInfo bookInfo) async {
    var _database = await GlobalInfo.dbDao.getConnection();
    await _database
        .delete(tableBook, where: "$bookColumnId=?", whereArgs: [bookInfo.id]);
    await _database.delete(tableChapter,
        where: "$chapterColumnBookId=?", whereArgs: [bookInfo.id]);
    File file = File(await GlobalInfo.dbDao.getFilePath() + bookInfo.savePath);
    File file2 = File(bookInfo.imgSavePath);
    try {
      file.deleteSync(recursive: true);
      file2.deleteSync();
    } catch (e) {
      GlobalInfo.logDao.saveLogToFile(e.toString());
    }
  }
}
