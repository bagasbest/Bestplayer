import 'package:bestplayer/database/database_service.dart';
import 'package:bestplayer/ui/order/order_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDesignList extends StatelessWidget {
  final List<DocumentSnapshot> document;
  final String role;

  OrderDesignList({
    required this.document,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i) {
        String orderId = document[i]['orderId'].toString();
        String uid = document[i]['uid'].toString();
        String desainUrl = document[i]['desainUrl'].toString();
        String keterangan = document[i]['keterangan'].toString();

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    desainUrl,
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  keterangan,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 30,),
                (role == 'admin')
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        child: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            await DatabaseService.deleteDesign(uid);
                          },
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        );
      },
    );
  }
}
