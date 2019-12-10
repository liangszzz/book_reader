
import 'package:book_reader/pages/settings/how_to_use.dart';
import 'package:book_reader/pages/settings/support_list.dart';
import 'package:flutter/material.dart';

class AppSetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("系统设置"),
        ),
        body: Column(
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, _, __) =>
                            SupportList(),
                      ));
                },
                child: Row(children: <Widget>[
                  Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          height: 80,
                          child: Text("支持列表"))),
                  Icon(Icons.view_list)
                ])),
            Divider(),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, _, __) =>
                            HowToUse(),
                      ));
                },
                child: Row(children: <Widget>[
                  Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          height: 80,
                          child: Text("使用说明"))),
                  Icon(Icons.info)
                ])),
            Divider(),
            GestureDetector(
                onTap: () {
                  showAboutDialog(
                      context: context,
                      applicationName: "Book Reader",
                      applicationVersion: "1.0.0",
                      children: <Widget>[Text("一个自用的小说阅读APP,请尽可能的支持正版.")]);
                },
                child: Row(children: <Widget>[
                  Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          height: 80,
                          child: Text("关于"))),
                  Icon(Icons.flag)
                ])),
          ],
        ));
  }
}
