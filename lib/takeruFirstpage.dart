import 'package:flutter/material.dart';

class Takerufirstpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("2ページ目"),
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
