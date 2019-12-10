import 'package:book_reader/global/global_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SupportList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var support = GlobalInfo.bookParseFactory.getSupport();
    return Scaffold(
      appBar: AppBar(title: Text("支持列表")),
      body: ListView.builder(
          itemBuilder: (context, i) {
            return Container(
              padding: EdgeInsets.all(20),
              child: Text(support[i].getUrlHead()),
            );
          },
          itemCount: support.length
      ),
    );
  }
}
