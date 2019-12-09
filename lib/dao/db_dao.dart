import 'dart:io';

import 'package:book_reader/entity/book_chapter.dart';
import 'package:book_reader/entity/book_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBDao {
  Directory _directory;

  String _dbPath;

  final String _dbName = "/book.db";

  Database _database;

  DBDao();

  Future<String> getFilePath() async {
    if (_directory == null) {
      _directory = await getExternalStorageDirectory();
    }
    return _directory.path;
  }

  Future<Database> getConnection() async {
    if (_directory == null) {
      _directory = await getExternalStorageDirectory();
      _dbPath = _directory.path + _dbName;
    }

    if (_database == null || !_database.isOpen) {
      _database = await openDatabase(_dbPath, version: 3,
          onCreate: (Database db, int version) async {
        await db.execute(
            "CREATE TABLE 'book' ('$bookColumnId' INTEGER NOT NULL,'$bookColumnName' TEXT,'$bookColumnAuthor' "
            "TEXT,'$bookColumnDesc' TEXT,'$bookColumnSavePath' TEXT,'$bookColumnNetPath' TEXT,'$bookColumnImgPath' TEXT,"
            "'$bookColumnLastReadChapter' INTEGER,'$bookColumnLastReadTime' TEXT,"
            "'$bookColumnLastUpdateTime' TEXT,'$bookColumnLastUpdateChapter' INTEGER,PRIMARY KEY ('$bookColumnId'));");

        await db.execute(
            "CREATE TABLE 'chapter' ('$chapterColumnId'  INTEGER NOT NULL,'$chapterColumnIndex'  INTEGER,'$chapterColumnBookId' INTEGER,"
            "'$chapterColumnName'  TEXT,'$chapterColumnNetPath'  TEXT, '$chapterColumnSavePath'  TEXT, PRIMARY KEY ('$chapterColumnId'));");
      });
    }
    return _database;
  }

  void closeConnection() async {
    _database.close();
  }
}
