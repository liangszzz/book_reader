import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(),
            child: TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                hintText: '手机号码',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(),
            child: TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: '密码',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
