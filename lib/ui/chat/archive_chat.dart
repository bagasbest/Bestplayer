import 'package:bestplayer/ui/chat/archive_chat_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/common.dart';

class ArchiveChat extends StatefulWidget {
  const ArchiveChat({Key? key}) : super(key: key);

  @override
  State<ArchiveChat> createState() => _ArchiveChatState();
}

class _ArchiveChatState extends State<ArchiveChat> {

  String role = "";
  String lastMessage = "";
  String dateTime = "";
  String adminName = "";
  String adminImage = "";
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  initializeData() {
    FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) {
      setState(() {
        role = value.data()!["role"];
        if (role == "user") {
          getAdminInfo();
        }
      });
    });
  }

  getAdminInfo() async {
    final prefs = await SharedPreferences.getInstance();
    adminName = prefs.getString('name') ?? '';
    adminImage = prefs.getString('image') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return (role != '')
        ? Scaffold(
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 16),
            child: StreamBuilder(
              stream: (role == "user")
                  ? FirebaseFirestore.instance
                  .collection('chat')
                  .where("uid", isEqualTo: '${Common.uid}$uid')
                  .snapshots()
                  : FirebaseFirestore.instance
                  .collection('chat')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return (snapshot.data!.size > 0)
                      ? ArchiveChatList(
                    document: snapshot.data!.docs,
                    adminName: adminName,
                    adminImage: adminImage,
                    role: role,
                  )
                      : _emptyData();
                } else {
                  return _emptyData();
                }
              },
            ),
          ),
        ],
      ),
    )
        : _emptyData();
  }

  Widget _emptyData() {
    return Container(
      child: Center(
        child: Text(
          'Tidak Ada Arsip\nTersedia',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }
}
