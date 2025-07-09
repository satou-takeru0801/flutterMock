import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class Takeruhomepage extends StatefulWidget {
  @override
  _TakeruhomepageState createState() => _TakeruhomepageState();
}

class _TakeruhomepageState extends State<Takeruhomepage> {
  String myId = '';

  @override
  void initState() {
    super.initState();
    _loadMyId();
  }

  Future<void> _loadMyId() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedId = prefs.getString('myId');
    if (savedId == null) {
      savedId = _generateRandomId();
      await prefs.setString('myId', savedId);
    }
    setState(() {
      myId = savedId!;
    });
  }

  String _generateRandomId() {
    final random = Random();
    return List.generate(9, (_) => random.nextInt(10)).join();
  }

  Future<void> _sendSosViaLine() async {
    try {
      Position pos = await Geolocator.getCurrentPosition();
      String mapUrl =
          "https://maps.google.com/?q=${pos.latitude},${pos.longitude}";
      String message = Uri.encodeComponent("【SOS】助けて！今ここにいます！\n$mapUrl");
      final lineUrl = Uri.parse("line://msg/text/$message");

      if (await canLaunchUrl(lineUrl)) {
        await launchUrl(lineUrl);
      } else {
        _showDialog("エラー", "LINEがインストールされていないか、起動できません。");
      }
    } catch (e) {
      _showDialog("エラー", "位置情報を取得できませんでした。\n$e");
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("娘SOS")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 自分のIDとコピー機能
            Row(
              children: [
                Expanded(
                    child:
                        Text("あなたのID: $myId", style: TextStyle(fontSize: 16))),
                IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: myId));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("IDをコピーしました")),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 40),

            // 超巨大SOSボタン
            ElevatedButton(
              onPressed: _sendSosViaLine,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: CircleBorder(),
                padding: EdgeInsets.all(100),
              ),
              child: Text("SOS",
                  style: TextStyle(fontSize: 40, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
