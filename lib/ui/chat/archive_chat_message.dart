import 'dart:isolate';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../widget/message_bubble.dart';
import '../../widget/theme.dart';
import '../logn_screen.dart';
import 'image_full.dart';

class ArchiveChatMessage extends StatefulWidget {
  final String uid;
  final String userName;
  String userImage;
  final String userUid;
  final String lastMessage;
  final String dateTime;
  final String status;
  final String adminUid;
  final String admName;
  String admImage;
  final String role;

  ArchiveChatMessage({
    required this.uid,
    required this.userName,
    required this.userImage,
    required this.userUid,
    required this.lastMessage,
    required this.dateTime,
    required this.status,
    required this.adminUid,
    required this.admName,
    required this.admImage,
    required this.role,
  });

  @override
  State<ArchiveChatMessage> createState() => _ArchiveChatMessageState();
}

class _ArchiveChatMessageState extends State<ArchiveChatMessage> {
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Themes(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            (widget.role == "user") ? widget.admName : widget.userName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
            ),
            //),
            // Row(
            //   children: [
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(100),
            //   child: Image.network(
            //     (widget.role == "user") ? widget.admImage : widget.userImage,
            //     width: 40,
            //     height: 40,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            // SizedBox(
            //   width: 16,
            // ),
            // ],
          ),
          leading: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(Icons.arrow_back)),
          backgroundColor: Color(0xFFD94555),
          elevation: 0,
        ),
        body: Container(
          color: Color(0xffebebeb),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: _chatShow(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot> _chatShow() {
    return StreamBuilder<QuerySnapshot>(
      stream: (widget.role == "user")
          ? _firestore
              .collection('chat')
              .doc(widget.userUid)
              .collection('messages')
              .where('isArchiveUser', isEqualTo: true)
              .snapshots()
          : _firestore
              .collection('chat')
              .doc(widget.userUid)
              .collection('messages')
              .where('isArchiveAdmin', isEqualTo: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text(
              '',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          );
        } else {
          final messages = snapshot.data!.docs.reversed;
          final myUid = FirebaseAuth.instance.currentUser!.uid;
          List<MessageBubble> messageBubbles = [];
          for (var message in messages) {
            final messageText = message.get('message').toString();
            final senderUid = message.get('senderUid').toString();
            final currentTime = message.get('currentTime').toString();
            final uid = message.get('uid').toString();
            final mediaMessage = message.get('mediaMessage').toString();
            final isArchiveUser = message.get('isArchiveUser');
            final isArchiveAdmin = message.get('isArchiveAdmin');

            final messageBubble = MessageBubble(
              messageText: messageText,
              senderUid: senderUid,
              currentTime: currentTime,
              uid: uid,
              mediaMessage: mediaMessage,
              myMessage: (myUid == senderUid) ? true : false,
              isArchiveAdmin: isArchiveAdmin,
              isArchiveUser: isArchiveUser,
            );
            messageBubbles.add(messageBubble);
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 16,
            ),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: messageBubbles[index],
                onTap: () {
                  if(messageBubbles[index].mediaMessage != 'text') {
                    showOptionDialog(context, messageBubbles[index]);
                  }
                },
              );
            },
            itemCount: messageBubbles.length,
          );
        }
      },
    );
  }

  void showOptionDialog(BuildContext context, MessageBubble messageBubble) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Pilihan'),
          children: <Widget>[
            (messageBubble.mediaMessage == 'image')
                ? SimpleDialogOption(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Route route = MaterialPageRoute(
                        builder: (context) => ImageFull(
                          image: messageBubble.messageText,
                        ),
                      );
                      Navigator.push(context, route);
                    },
                    child: const Text('Lihat Full Gambar'),
                  )
                : Container(),
            (messageBubble.mediaMessage == 'pdf')
                ? SimpleDialogOption(
                    onPressed: () {
                      downloadPdf(messageBubble.messageText);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Download PDF'),
                  )
                : Container(),
          ],
        );
      },
    );
  }

  Future<void> downloadPdf(String messageText) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getExternalStorageDirectory();

      await FlutterDownloader.enqueue(
        url: messageText,
        savedDir: baseStorage!.path,
        showNotification: true,
        // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      );
    }
  }

  ReceivePort _port = ReceivePort();

  void initializeData() {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      if (status == DownloadTaskStatus.complete) {
        toast('Download Selesai');
      }

      setState(() {});
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }
}
