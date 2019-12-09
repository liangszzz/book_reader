import 'package:book_reader/entity/book_info.dart';
import 'package:flutter/material.dart';

class BookChapters extends StatelessWidget {

  final BookInfo bookInfo;

  const BookChapters({Key key, this.bookInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("目录"),
        ),
        body: ListView.separated(
            itemBuilder: (context, i) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context, i);
                },
                child: Text(this.bookInfo.chapters[i].name,style: TextStyle(fontSize: 16)),
              );
            },
            separatorBuilder: (context, i) => Divider(),
            itemCount: bookInfo.chapters.length));
  }
}
