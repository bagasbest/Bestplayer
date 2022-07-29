import 'package:bestplayer/ui/chat/all_chat.dart';
import 'package:bestplayer/ui/chat/archive_chat.dart';
import 'package:bestplayer/ui/chat/unread_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/common.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  void initState() {
    super.initState();
    setAdminData();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: buildMaterialColor(const Color(0xFFD94555)),
      ),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Inbox'),
            bottom: const TabBar(tabs: [
              Tab(text: 'Semua',),
              Tab(text: 'Belum Dibaca',),
              Tab(text: 'Arsip',),
            ]),
          ),
          body: TabBarView(
            children: [
              AllChat(),
              UnreadChat(),
              ArchiveChat(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> setAdminData() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    FirebaseFirestore.instance
        .collection('users')
        .doc(Common.uid)
        .get()
        .then((value) {
          prefs.setString('name', value.data()!["name"]);
          prefs.setString('image', value.data()!["image"]);
    });
  }

  MaterialColor buildMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }
}
