import 'package:flutter/material.dart';
import 'package:pardon_us/animation_transition/fade_transition.dart';
import 'package:pardon_us/models/create_Mcqs_Model.dart';
import 'package:pardon_us/models/urlLauncher.dart';
import 'package:provider/provider.dart';
import '../class_screen.dart';
import 'package:pardon_us/models/managing_directory.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pardon_us/models/assignmentModel.dart';
class StudentUploadAssignment extends StatefulWidget {
  AssignmentModel assDetails;
  StudentUploadAssignment({this.assDetails});
  @override
  _StudentUploadAssignmentState createState() => _StudentUploadAssignmentState();
}

class _StudentUploadAssignmentState extends State<StudentUploadAssignment> {
  Launcher _launch;
  Directory _dir;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PARDON US'),
      ),
      body: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 500.0,
                  height: 80.0,
                  child: ListTile(
                    leading: Icon(Icons.message,color: Colors.red,),
                    title: Text(widget.assDetails.assignmentTile),
                    subtitle: Text('Click to download file'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(widget.assDetails.dueDate,
                          style: TextStyle(color: Colors.green),
                        ),
                        SizedBox(height: 2.0,),
                        Text(widget.assDetails.dueTime,
                            style: TextStyle(color: Colors.green)
                        ),
                      ],
                    ),
                    onTap: ()async{
                      _launch=Launcher();
                      _dir=Directory();
                      try{
                        if(await canLaunch(widget.assDetails.fileUrl))
                        {
                          await launch(widget.assDetails.fileUrl);
                        }
                      }
                      catch(e){
                        print(e);
                      }
                    },
                  ),
                ),
                SizedBox(height: 20.0,width: 530.0,child: Divider(color: Colors.blueGrey,),),
                Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: Container(
                    height: 400.0,
                    width: 550.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        border: Border.all(
                            color: Colors.black26,
                            width: 1.0
                        )
                    ),
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.file_upload,color: Colors.indigo,size: 38.0),
                        ),
                      ),
                    ),

                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 90.0),
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 7.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0)
                    ),
                    color: Colors.blueAccent,
                    child: Text('Submit',style: TextStyle(fontSize: 20.0,color: Colors.white),),
                    onPressed: (){
                      Navigator.push(context, FadeRoute(page: ClassScreen()));
                    },
                  ),
                )

              ],
            ),
          )
      ),

    );
  }
}
