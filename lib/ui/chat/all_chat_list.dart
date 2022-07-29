import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../common/common.dart';

class AllChatList extends StatelessWidget {
  final List<DocumentSnapshot> document;
  final String adminName;
  final String adminImage;
  final String role;

  AllChatList({
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
            // Route route = MaterialPageRoute(
            //   builder: (context) => PengaduanDetail(
            //     uid: uid,
            //     title: title,
            //     pengaduan: pengaduan,
            //     address: address,
            //     latitude: latitude,
            //     longitude: longitude,
            //     image: image,
            //     status: status,
            //   ),
            // );
            // Navigator.push(context, route);
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
                                height: 60,
                                width: 60,
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
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    lastMessage,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 70,
                              alignment: Alignment.topCenter,
                              child: Text(
                                dateTime,
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        )
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
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.red,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(
                                      (userImage != "")
                                          ? userImage
                                          : 'https://via.placeholder.com/150',
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
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    lastMessage,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 70,
                              alignment: Alignment.topCenter,
                              child: Text(
                                dateTime,
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              dateTime,
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            (status != '')
                                ? Container(
                                    height: 25,
                                    child: Text(status),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: (status == "delivered")
                                            ? Colors.orange
                                            : (status == "revision")
                                                ? Colors.purple
                                                : (status == "accepted")
                                                    ? Colors.lightGreenAccent
                                                    : (status == "payment")
                                                        ? Colors.blue
                                                        : Colors.green),
                                  )
                                : Container()
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
