import 'package:bestplayer/database/database_service.dart';
import 'package:bestplayer/ui/homepage_screen.dart';
import 'package:bestplayer/ui/logn_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widget/theme.dart';
import 'order_disign_list.dart';

class OrderDesign extends StatefulWidget {
  final String orderId;
  final String role;
  final int revisiLeft;
  final String status;


  OrderDesign({
    required this.orderId,
    required this.role,
    required this.revisiLeft,
    required this.status,
  });

  @override
  State<OrderDesign> createState() => _OrderDesignState();
}

class _OrderDesignState extends State<OrderDesign> {
  final _keteranganRevisi = TextEditingController();
  bool isAccDeclineShow = false;

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
          title: Text("Desain Jersey"),
        ),
        body: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: (widget.role == 'user' && widget.revisiLeft > 0)
                    ? 150
                    : (widget.role == 'user' && widget.revisiLeft == 0)
                        ? 70
                        : 0,
              ),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('design')
                    .where('orderId', isEqualTo: widget.orderId)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return (snapshot.data!.size > 0)
                        ? OrderDesignList(
                            document: snapshot.data!.docs.reversed.toList(),
                            role: widget.role,
                          )
                        : _emptyData();
                  } else {
                    return _emptyData();
                  }
                },
              ),
            ),
            (isAccDeclineShow)
                ? Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: (widget.revisiLeft > 0) ? 70 : 0,
                          left: 16,
                          right: 16,
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: InkWell(
                            onTap: () async {
                              String uid =
                                  FirebaseAuth.instance.currentUser!.uid;
                              bool accepted =
                                  await DatabaseService.updateOrderStatus(
                                      widget.orderId, 'Accepted');
                              bool updateChatStatus =
                                  await DatabaseService.updateChat(
                                      uid, 'Accepted');

                              if (accepted && updateChatStatus) {
                                toast('Berhasil Menerima Desain');
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => HomepageScreen()),
                                    (Route<dynamic> route) => false);
                              } else {
                                toast('Gagal Menerima Desain');
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xFFD94555),
                              ),
                              child: Center(
                                child: Text(
                                  'ACC',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      (widget.revisiLeft > 0)
                          ? Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                              ),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: InkWell(
                                  onTap: () async {
                                    _showRequestRevision();
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.red[200],
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Permintaan Revisi',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Widget _emptyData() {
    return Container(
      child: Center(
        child: Text(
          'Tidak Ada Desain\nTersedia',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }

  _showRequestRevision() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          backgroundColor: Color(0xFFD94555),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  'Konfirmasi Permintaan Revisi',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                ),
                child: Divider(
                  color: Colors.white,
                  height: 3,
                  thickness: 3,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Silahkan masukkan poin - poin untuk direvisi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 10,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: _keteranganRevisi,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: 'Keterangan Revisi',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 26,
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
              onPressed: () async {
                String uid = FirebaseAuth.instance.currentUser!.uid;
                bool requestRevision = await DatabaseService.requestRevision(
                  widget.orderId,
                  widget.revisiLeft - 1,
                  _keteranganRevisi.text,
                );
                bool updateChatStatus =
                    await DatabaseService.updateChat(uid, 'Revision');

                if (requestRevision && updateChatStatus) {
                  toast('Berhasil Meminta Revisi, Revisi anda sisa ${widget.revisiLeft-1}');

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => HomepageScreen()),
                      (Route<dynamic> route) => false);
                } else {
                  toast('Gagal Meminta Revisi');
                }
              },
            ),
          ],
          elevation: 10,
        );
      },
    );
  }

  void initializeData() {
    FirebaseFirestore.instance
        .collection('design')
        .where('orderId', isEqualTo: widget.orderId)
        .get()
        .then((value) {
      if (value.size > 0  && (widget.status == 'Delivered' || widget.status == 'Revision')) {
        setState(() {
          if (widget.role == 'user') {
            isAccDeclineShow = true;
          } else {
            isAccDeclineShow = false;
          }
        });
      }
    });
  }
}
