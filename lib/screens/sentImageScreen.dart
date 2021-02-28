import 'dart:io' as io;
import 'dart:html'as html;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pardon_us/models/messagesMethods.dart';

class SendImage extends StatefulWidget {
  PlatformFile _image;
  String senderName,classCode;
  SendImage(this._image,this.senderName,this.classCode);

  @override
  _SendImageState createState() => _SendImageState();
}

class _SendImageState extends State<SendImage> {
  MessengerMethods sendImg;
  MediaQueryData mediaQueryData= MediaQueryData();

  @override
  Widget build(BuildContext context) {
    html.File htmlFile=html.File(widget._image.bytes,widget._image.name);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('PARDON US'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top:5.0,left: 12.0,right: 12.0,bottom: 90.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black26,
              image: DecorationImage(
                image: MemoryImage(widget._image.bytes),
                  fit: BoxFit.contain
              )

            ),
          ),
        ),

      ),
      floatingActionButton: GestureDetector(
        child: Container(
          height: 60.0,
          width: 60.0,
          decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
          child: Icon(Icons.arrow_forward_ios,color: Colors.white,),
      ),
        onTap: ()async{
          sendImg= MessengerMethods();
          try {
            sendImg.sendImageWeb(widget._image, widget.senderName, widget.classCode);
            Navigator.pop(context);
          }
          catch(e){
              print(e);
          }

        },
    )
    );

  }
}
