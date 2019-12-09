import 'package:book_reader/entity/book_info.dart';
import 'package:book_reader/global/global_info.dart';
import 'package:flutter/material.dart';

class BookChapters extends StatelessWidget {
  final BookInfo bookInfo;

  const BookChapters({Key key, this.bookInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController _controller = new ScrollController();
    return Scaffold(
        appBar: AppBar(
          title: Text("目录"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_upward),
              onPressed: () {
                  _controller.animateTo(0,
                          duration: GlobalInfo.duration, curve: Curves.ease);
              },
            ),
            IconButton(
              icon: Icon(Icons.arrow_downward),
              onPressed: () {
                  var height = MediaQuery.of(context).size.height;
                  _controller.animateTo(_controller.position.pixels + height - 160,
                          duration: Duration(milliseconds: 10), curve: Curves.ease);
              },
            )
          ],
        ),
        body: ListView.separated(
            controller: _controller,
            itemBuilder: (context, i) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context, i);
                },
                child: Text(this.bookInfo.chapters[i].name,
                    style: TextStyle(fontSize: 16)),
              );
            },
            separatorBuilder: (context, i) => Divider(),
            itemCount: bookInfo.chapters.length));
  }
}
