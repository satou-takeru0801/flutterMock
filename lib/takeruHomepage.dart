import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class Takeruhomepage extends StatefulWidget {
  @override
  _TakeruhomepageState createState() => _TakeruhomepageState();
}

class _TakeruhomepageState extends State<Takeruhomepage> {
  String myId = '';
  List<String> friends = [];
  TextEditingController friendController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadIdAndFriends();
  }

  Future<void> _loadIdAndFriends() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getString('myId') ?? _generateId();
    final savedFriends = prefs.getStringList('friends') ?? [];
    await prefs.setString('myId', savedId);
    setState(() {
      myId = savedId;
      friends = savedFriends;
    });
  }

  String _generateId() {
    final rand = Random();
    return List.generate(9, (_) => rand.nextInt(10)).join();
  }

  Future<void> _addFriend(String id) async {
    if (id.isNotEmpty && !friends.contains(id) && friends.length < 2) {
      final prefs = await SharedPreferences.getInstance();
      friends.add(id);
      await prefs.setStringList('friends', friends);
      setState(() {});
    }
  }

  Future<void> _sendSOS() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String location = "緯度: ${position.latitude}, 経度: ${position.longitude}";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('SOS送信'),
        content: Text('次のフレンドに通知：\n${friends.join(", ")}\n\n位置情報：$location'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('OK')),
        ],
      ),
    );

    // TODO: Firebase連携などで通知送信処理
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("娘SOS ホーム")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("あなたのID: $myId", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: CircleBorder(),
                padding: EdgeInsets.all(60),
              ),
              onPressed: _sendSOS,
              child: Text("SOS",
                  style: TextStyle(fontSize: 32, color: Colors.white)),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              child: Text("フレンド追加"),
            ),
            TextField(
              controller: friendController,
              decoration: InputDecoration(labelText: "フレンドIDを入力"),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () {
                _addFriend(friendController.text.trim());
                friendController.clear();
              },
              child: Text("フレンドに追加"),
            ),
            SizedBox(height: 20),
            Text("フレンド一覧:"),
            ...friends.map((id) => ListTile(title: Text(id))),
          ],
        ),
      ),
    );
  }
}
