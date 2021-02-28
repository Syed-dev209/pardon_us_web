import 'package:flutter/material.dart';

class LargeStartScreen extends StatefulWidget {
  List<ListTile> myClasses,myCourses;
  LargeStartScreen({this.myClasses,this.myCourses});
  @override
  _LargeStartScreenState createState() => _LargeStartScreenState();
}

class _LargeStartScreenState extends State<LargeStartScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text('MY CLASSES ',style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            // foreground: new Paint()..shader=linearGradient
            color: Colors.black26
        ),),
        SizedBox(height: 10.0,),
        GridView.count(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          crossAxisCount: 4,
          children: widget.myClasses,
        ),
        SizedBox(height: 30.0,),
        Text('MY COURSES ',style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            // foreground: new Paint()..shader=linearGradient
            color: Colors.black26
        ),),
        SizedBox(height: 10.0,),
        GridView.count(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          crossAxisCount: 4,
          children: widget.myCourses,
        )
      ],
    );
  }
}
