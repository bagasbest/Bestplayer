import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../common/common.dart';
import 'archive_chat_message.dart';

class ArchiveChatList extends StatelessWidget {
  final List<DocumentSnapshot> document;
  final String adminName;
  final String adminImage;
  final String role;

  ArchiveChatList({
    required this.document,
    required this.adminName,
    required this.adminImage,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i) {
        String uid;
        String userName;
        String admName;
        String userImage;
        String admImage;
        String userUid;
        String adminUid;
        String lastMessage;
        String dateTime;
        String status;

        uid = document[i]['uid'].toString();
        userName = document[i]['userName'].toString();
        userImage = document[i]['userImage'].toString();
        userUid = document[i]['userUid'].toString();
        lastMessage = document[i]['lastMessage'].toString();
        dateTime = document[i]['dateTime'].toString();
        status = document[i]['status'].toString();
        adminUid = Common.uid;
        admName = adminName;
        admImage = adminImage;

        print(admName);

        return GestureDetector(
          onTap: () {
            Route route = MaterialPageRoute(
              builder: (context) => ArchiveChatMessage(
                uid: uid,
                userName: userName,
                userImage: userImage,
                userUid: userUid,
                lastMessage: lastMessage,
                dateTime: dateTime,
                status: status,
                adminUid: adminUid,
                admName: admName,
                admImage: admImage,
                role: role,
              ),
            );
            Navigator.push(context, route);
          },
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.white,
            child: Container(
              height: 80,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 16),
              child: (role == "user")
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.all(3),
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.red,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(admImage,
                                      fit: BoxFit.cover),
                                )),
                            SizedBox(
                              width: 16,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    admName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Berisi Arsip Pesan',
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 11,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.all(3),
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.red,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(
                                      (userImage != "")
                                          ? userImage
                                          : Common.placeholderImage,
                                      fit: BoxFit.cover),
                                )),
                            SizedBox(
                              width: 16,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Berisi Arsip Pesan',
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 11,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
