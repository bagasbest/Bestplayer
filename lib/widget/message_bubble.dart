import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String messageText;
  final String senderUid;
  final String currentTime;
  final String uid;
  final String mediaMessage;
  final bool myMessage;
  final bool isArchiveAdmin;
  final bool isArchiveUser;

  MessageBubble({
    required this.messageText,
    required this.senderUid,
    required this.currentTime,
    required this.uid,
    required this.mediaMessage,
    required this.myMessage,
    required this.isArchiveAdmin,
    required this.isArchiveUser,
  });

  final senderBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(20),
    bottomLeft: Radius.circular(20),
    topRight: Radius.circular(20),
  );

  final otherBorderRadius = BorderRadius.only(
    topRight: Radius.circular(20),
    bottomRight: Radius.circular(20),
    topLeft: Radius.circular(20),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            myMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Text(
          //   sender,
          //   style: TextStyle(
          //     fontSize: 12.0,
          //     color: Colors.black54,
          //   ),
          // ),
          Material(
            color: myMessage ? Color(0xFFD94555) : Colors.white,
            borderRadius: myMessage ? senderBorderRadius : otherBorderRadius,
            elevation: 5.0,
            child: (mediaMessage == "text")
                ? Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Text(
                      messageText,
                      style: TextStyle(
                        color: myMessage ? Colors.white : Colors.black54,
                        fontSize: 15.0,
                      ),
                    ),
                  )
                : (mediaMessage == 'image')
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Container(
                          height: 150,
                          width: 150,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(messageText, fit: BoxFit.cover,),
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Container(
                          width: 200,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.picture_as_pdf,
                                color: (myMessage) ? Colors.white : Colors.red,
                                size: 50,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  messageText,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: (myMessage) ? Colors.white : Colors.black,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            currentTime,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
