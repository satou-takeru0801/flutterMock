import 'package:flutter/material.dart';
import 'package:flutter_application_1/takeruFirstpage.dart';
import 'package:flutter_application_1/takeruSecondpage.dart';
import 'FirstPage.dart';
import 'SecondPage.dart';

class Takeruhomepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red, // 背景を赤に設定
      body: Center(
        child: GestureDetector(
          onTap: () {
            // SOSボタンを押したときの処理（後で追加可能）
          },
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white, // 白い丸
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              'SOS',
              style: TextStyle(
                color: Colors.black, // 黒字
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
