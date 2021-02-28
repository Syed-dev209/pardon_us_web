import 'package:flutter/material.dart';

class SmallStartScreen extends StatefulWidget {
  List<ListTile> myClasses,myCourses;
SmallStartScreen(this.myClasses,this.myCourses);
  @override
  _SmallStartScreenState createState() => _SmallStartScreenState();
}

class _SmallStartScreenState extends State<SmallStartScreen> {
  MediaQueryData _queryData;
  @override
  Widget build(BuildContext context) {
    _queryData= MediaQuery.of(context);
    return Column(
      children: [
        Classes(_queryData.size.width, 'https://cdn.pixabay.com/photo/2018/09/15/16/56/teacher-3679814_960_720.jpg', 'MY CLASSES', widget.myClasses),
        SizedBox(height: 5.0),
        Classes(_queryData.size.width, 'https://www.kindpng.com/picc/m/109-1097640_student-university-cartoon-hd-png-download.png', 'MY COURSES', widget.myCourses)

      ],
    );;
  }
}



Widget Classes(double width,String imagePath,String expTitle,List<ListTile> list){
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.deepPurple,Colors.blue,Colors.white],
  ).createShader(new Rect.fromLTWH(0.0,0.0, 200.0, 70.0));
  return Card(
    elevation: 3.0,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0)
    ),
    child: Column(
      children: [
        Container(
          width: width,
          height: 190.0,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(imagePath)
              )
          ),
        ),
        ExpansionTile(
          title: Text(expTitle,style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              // foreground: new Paint()..shader=linearGradient
              color: Colors.black26
          ),),
          children: [
            Column(
                children:list
            )
          ],
        )
      ],
    ),
  );

}