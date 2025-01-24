import 'package:flutter/material.dart';
import 'package:flutter_application_1/takeruFirstpage.dart';
import 'package:flutter_application_1/takeruSecondpage.dart';
import 'FirstPage.dart';
import 'SecondPage.dart';

class Takeruhomepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ホーム"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              child: Text("1ページ目に遷移する"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Takerufirstpage(),
                    ));
              },
            ),
            TextButton(
              child: Text("2ページ目に遷移する"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Takerusecondpage(),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
