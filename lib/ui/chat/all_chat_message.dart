import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:bestplayer/ui/chat/image_full.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/common.dart';
import '../../database/database_service.dart';
import '../../widget/message_bubble.dart';
import '../../widget/theme.dart';

class AllChatMessage extends StatefulWidget {
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

  AllChatMessage({
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
  State<AllChatMessage> createState() => _AllChatMessageState();
}

class _AllChatMessageState extends State<AllChatMessage> {
  final _firestore = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final _messageTextController = TextEditingController();
  bool _isProcessing = false;
  String mediaMessage = "";
  XFile? _image;
  File? filePdf;

  String urlImage = '';
  String urlPdf = '';

  String _currentTime() {
    var now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yy, kk:mm').format(now);
    return formattedDate;
  }

  @override
  void initState() {
    super.initState();

    if (widget.admImage == "") {
      widget.admImage = Common.placeholderImage;
    }

    if (widget.userImage == "") {
      widget.userImage = Common.placeholderImage;
    }

    initializeData();
    setState(() {});
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
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        showAttachmentOption(context);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.attach_file,
                          color: Colors.white,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color(0xFFD94555),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageTextController,
                        decoration: InputDecoration(
                          hintText: 'Ketik pesan',
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (_) {
                          _image = null;
                          filePdf = null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    RaisedButton(
                      child: Text(
                        'KIRIM',
                        style: TextStyle(color: Colors.white),
                      ),
                      disabledColor:
                          (_isProcessing) ? Color(0xFFE3959D) : Color(0xFFD94555),
                      color:
                          (_isProcessing) ? Color(0xFFE3959D) : Color(0xFFD94555),
                      textTheme: ButtonTextTheme.primary,
                      onPressed: (_isProcessing)
                          ? null
                          : () async {
                              if (_messageTextController.text.isNotEmpty) {
                                mediaMessage = 'text';
                                await sendMessage();
                              } else {
                                _toast('Pesan tidak boleh kosong');
                              }
                            },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot> _chatShow() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('chat')
          .doc(widget.userUid)
          .collection('messages')
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
            reverse: true,
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 16,
            ),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: messageBubbles[index],
                onTap: () {
                  showOptionDialog(context, messageBubbles[index]);
                },
              );
            },
            itemCount: messageBubbles.length,
          );
        }
      },
    );
  }

  void showAttachmentOption(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Pilih Media Upload'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                uploadImage();
              },
              child: const Text('Gambar'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                pickPdf();
              },
              child: const Text('Pdf'),
            ),
          ],
        );
      },
    );
  }

  Future<void> uploadImage() async {
    _image = await DatabaseService.getImageGallery();
    urlImage = (_image != null)
        ? await DatabaseService.uploadImageReport(_image!)
        : '';

    if (urlImage != '') {
      mediaMessage = 'image';
      sendMessage();
    }
  }

  Future<void> pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      filePdf = File(result.files.single.path.toString());
      urlPdf = await DatabaseService.uploadPdf(filePdf);

      if (urlPdf != '') {
        mediaMessage = 'pdf';
        sendMessage();
      }
    } else {
      // User canceled the picker
    }
  }

  Future<void> sendMessage() async {
    setState(() {
      _isProcessing = true;
    });
    var docRef = _firestore.collection('chat').doc(widget.userUid);
    await docRef.get().then((doc) {
      if (doc.exists) {
        print("Document data ada: ${doc.data()}");
        _firestore.collection('chat').doc(widget.userUid).update({
          'lastMessage': (mediaMessage == 'text')
              ? _messageTextController.text
              : (mediaMessage == 'image')
                  ? urlImage
                  : urlPdf,
          'dateTime': _currentTime(),
        });
      } else {
        print('tidak ada');
      }
    }).catchError((error) {
      print('Get doc: ' + error);
    });

    String uid = DateTime.now().millisecondsSinceEpoch.toString();
    await _firestore
        .collection('chat')
        .doc(widget.userUid)
        .collection('messages')
        .doc(uid)
        .set({
      'message': (_messageTextController.text != '')
          ? _messageTextController.text
          : (_image != null)
              ? urlImage
              : urlPdf,
      'mediaMessage': mediaMessage,
      'currentTime': _currentTime(),
      'uid': uid,
      'senderUid': (widget.role == 'user') ? widget.userUid : widget.adminUid,
      'isArchiveUser': false,
      'isArchiveAdmin': false,
    });
    _messageTextController.clear();
    setState(() {
      _isProcessing = false;
      _messageTextController.text = '';
      _image = null;
      filePdf = null;
    });
  }

  void showOptionDialog(BuildContext context, MessageBubble messageBubble) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Pilihan'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                if (widget.role == 'user') {
                  saveAsArchive(messageBubble.isArchiveUser, messageBubble.uid);
                } else {
                  saveAsArchive(
                      messageBubble.isArchiveAdmin, messageBubble.uid);
                }
              },
              child: (widget.role == 'user')
                  ? Text((!messageBubble.isArchiveUser)
                      ? 'Simpan Sebagai Arsip'
                      : 'Hapus dari arsip')
                  : Text((!messageBubble.isArchiveAdmin)
                      ? 'Simpan Sebagai Arsip'
                      : 'Hapus dari arsip'),
            ),
            (messageBubble.mediaMessage == 'image')
                ? SimpleDialogOption(
                    onPressed: () {
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

  void saveAsArchive(bool isArchive, String uid) {
    if (widget.role == 'user') {
      _firestore
          .collection('chat')
          .doc(widget.userUid)
          .collection('messages')
          .doc(uid)
          .update({'isArchiveUser': !isArchive});
    } else {
      _firestore
          .collection('chat')
          .doc(widget.userUid)
          .collection('messages')
          .doc(uid)
          .update({'isArchiveAdmin': !isArchive});
    }

    if (isArchive) {
      _toast('Berhasil Menghapus Arsip');
    } else {
      _toast('Berhasil Menyimpan Arsip');
    }
  }

  Future<void> downloadPdf(String messageText) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getExternalStorageDirectory();
      await FlutterDownloader.enqueue(
        saveInPublicStorage: true,
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
        _toast('Download Selesai');
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

void _toast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(0xFFD94555),
      textColor: Colors.white,
      fontSize: 16.0);
}
