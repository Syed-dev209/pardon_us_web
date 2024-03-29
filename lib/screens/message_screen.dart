import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pardon_us/animation_transition/fade_transition.dart';
import 'package:pardon_us/components/msgbubbles.dart';
import 'package:pardon_us/models/login_methods.dart';
import 'package:pardon_us/models/messagesMethods.dart';
import 'package:pardon_us/screens/sendVideoScreeen.dart';
import 'package:pardon_us/screens/sentImageScreen.dart';
import 'package:pardon_us/models/managing_directory.dart';

class MessagesScreen extends StatefulWidget {
  String classCode, username;

  MessagesScreen({this.classCode, this.username});
  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  MessengerMethods msgs;
  bool isWriting = false, showSpinner = false;
  final msgTextController = TextEditingController();
  String sender, text, type;
  Directory getimg;
  PlatformFile _image, _video;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('messages')
                .doc(widget.classCode)
                .collection('classMessage')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child:
                      CircularProgressIndicator(backgroundColor: Colors.indigo),
                );
              }
              final messages = snapshot.data.docs;
              List<MessageBubble> msgBubbles = [];
              for (var msg in messages) {
                sender = msg.data()['sender'];
                text = msg.data()['text'];
                type = msg.data()['type'];
                final msgBubble = MessageBubble(
                  sender: sender,
                  text: text,
                  isMe: widget.username == sender,
                  type: type,
                );
                msgBubbles.add(msgBubble);
              }
              return msgBubbles.isNotEmpty
                  ? Expanded(
                      child: ListView(reverse: true, children: msgBubbles),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Text(
                          'No Messages yet',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 40.0,
                              color: Colors.indigo[100]),
                        ),
                      ),
                    );
            },
          ),
          //
          Container(
            padding: EdgeInsets.only(left: 8.0, bottom: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    cursorColor: Colors.green,
                    controller: msgTextController,
                    decoration: InputDecoration(
                        prefixIcon: IconButton(
                          icon: Icon(
                            Icons.insert_emoticon,
                            color: Colors.indigo,
                            size: 30.0,
                          ),
                          onPressed: () {},
                        ),
                        suffixIcon: Container(
                          padding: EdgeInsets.only(right: 4.0),
                          width: 70.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: IconButton(
                                  padding: const EdgeInsets.all(0.0),
                                  icon: Icon(
                                    Icons.image,
                                    color: Colors.indigo,
                                    size: 30.0,
                                  ),
                                  onPressed: () async {
                                    getimg = Directory();
                                    try {
                                      _image = await getimg.chooseImage();
                                      if (_image != null) {
                                        Navigator.push(
                                            context,
                                            FadeRoute(
                                                page: SendImage(
                                                    _image,
                                                    widget.username,
                                                    widget.classCode)));
                                      }
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  padding: const EdgeInsets.all(0.0),
                                  icon: Icon(
                                    Icons.videocam,
                                    color: Colors.indigo,
                                    size: 32.0,
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      showSpinner = true;
                                    });
                                    MessengerMethods obj =
                                        new MessengerMethods();
                                    try {
                                      _video = await obj.chooseVideoWeb();
                                      String url = await obj.sendVideoWeb(
                                          _video,
                                          widget.username,
                                          widget.classCode);
                                      if (url != null) {
                                        setState(() {
                                          showSpinner = false;
                                        });
                                        Navigator.push(
                                            context,
                                            FadeRoute(
                                                page: SendVideo(
                                                    url,
                                                    widget.username,
                                                    widget.classCode)));
                                      }
                                    } catch (e) {
                                      setState(() {
                                        showSpinner = false;
                                      });
                                      print(e);
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        hintText: 'Type here....',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.green,
                    size: 30.0,
                  ),
                  onPressed: () async {
                    msgs = new MessengerMethods();
                    try {
                      msgs.sendTextMsg(
                          senderName: widget.username,
                          classCode: widget.classCode,
                          textMessage: msgTextController.text);
                      msgTextController.clear();
                    } catch (e) {
                      print(e);
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
