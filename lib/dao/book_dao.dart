import 'package:book_reader/entity/book_info.dart';
import 'package:book_reader/parse/book_info_parse.dart';

class BookDao {
  BookParseFactory bookParseFactory = BookParseFactory();

  void loadBookInfo(String url) async {}

  void loadContent() {}

  Future<BookInfo> addBook(String url) async {
    BookInfo parseBookInfo = await bookParseFactory.parseBookInfo(url);
    return parseBookInfo;
  }
}
