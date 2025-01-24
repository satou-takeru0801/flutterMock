import 'package:flutter/material.dart';

class Takerusecondpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("1ページ目"),
      ),
      body: Center(
        child: TextButton(
          child: Text("ホームに戻る"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
