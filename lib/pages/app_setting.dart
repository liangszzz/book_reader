import 'package:flutter/material.dart';

class AppSetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("系统设置"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Text("setting"),
      ),
    );
  }
}
