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
  final TextEditingController friendController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLocalData();
  }

  Future<void> _loadLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedId = prefs.getString('myId');
    if (savedId == null) {
      savedId = _generateRandomId();
      await prefs.setString('myId', savedId);
    }
    List<String> savedFriends = prefs.getStringList('friends') ?? [];

    setState(() {
      myId = savedId!;
      friends = savedFriends;
    });
  }

  String _generateRandomId() {
    final random = Random();
    return List.generate(9, (_) => random.nextInt(10)).join();
  }

  Future<void> _addFriend(String id) async {
    if (id.isEmpty || friends.contains(id) || friends.length >= 2) return;
    friends.add(id);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('friends', friends);
    setState(() {});
  }

  Future<void> _sendSOS() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return _showDialog("エラー", "位置情報サービスが無効です。");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return _showDialog("エラー", "位置情報の許可が必要です。");
      }
    }

    Position pos = await Geolocator.getCurrentPosition();
    String message = "現在地:\n緯度: ${pos.latitude}\n経度: ${pos.longitude}\n\n"
        "以下のフレンドに送信:\n${friends.join('\n')}";

    _showDialog("SOS発信", message);
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
            Text("あなたのID: $myId", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendSOS,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: CircleBorder(),
                padding: EdgeInsets.all(60),
              ),
              child: Text("SOS",
                  style: TextStyle(fontSize: 32, color: Colors.white)),
            ),
            SizedBox(height: 20),
            TextField(
              controller: friendController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "フレンドIDを入力"),
            ),
            ElevatedButton(
              onPressed: () {
                _addFriend(friendController.text.trim());
                friendController.clear();
              },
              child: Text("フレンド追加"),
            ),
            SizedBox(height: 20),
            Text("登録済みフレンド:"),
            ...friends.map((id) => ListTile(title: Text(id))),
          ],
        ),
      ),
    );
  }
}
