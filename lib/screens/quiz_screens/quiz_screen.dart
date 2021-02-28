import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pardon_us/animation_transition/fade_transition.dart';
import 'package:pardon_us/components/quiz_card.dart';
import 'package:pardon_us/animation_transition/icon_flodable_animation.dart';
import 'package:pardon_us/models/userDeatils.dart';
import 'package:pardon_us/screens/quiz_screens/mcqs_create_screen.dart';
import 'package:pardon_us/screens/quiz_screens/teacher_upload_quiz_screen.dart';
import 'package:pardon_us/screens/webQuizScreens/largeQuizScreen.dart';
import 'package:pardon_us/screens/webQuizScreens/smallQuizScreen.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class QuizScreen extends StatefulWidget {
  String participantStatus;
  QuizScreen({this.participantStatus});
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  FirebaseFirestore _firestore;
  List<ListTile> quizcards=[];

  Widget buildTile(String quizTitle,String duedate,String dueTime,String type,String docId,String imgUrl){
    return ListTile(
      title: QuizCard(quizTitle,duedate,dueTime,type,widget.participantStatus,docId,imgUrl),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firestore= FirebaseFirestore.instance;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    quizcards.clear();
  }
  @override
  Widget build(BuildContext context) {
    print(widget.participantStatus);
    return  Stack(
        children:[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ListView(
              children: [
                widget.participantStatus=='Teacher'?
                    LayoutBuilder(
                      builder: (context,constraints)
                      {
                        List<ListTile> teacherCards=[];
                        for(int i= 0;i<=1;i++)
                          {
                            var a = ListTile(
                              title:QuizCard('Students list','Date','Time','Mcqs','Teacher',"","") ,
                            );
                            teacherCards.add(a);
                          }
                        if(constraints.maxWidth<839)
                          {


                            return SmallQuizScreen(teacherCards);
                          }
                        else
                          {
                            return LargeQuizScreen(teacherCards);
                          }
                      },
                    )
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   crossAxisAlignment: CrossAxisAlignment.end,
                //   children: [
                //     QuizCard('Students list attempted mcqs','Date','Time','Mcqs','Teacher',"",""),
                //     QuizCard('Students uploaded file','Date','Time','file','Teacher',"",""),
                //   ],
                // ):
                //For Students
               :StreamBuilder<QuerySnapshot>(
                 stream: _firestore.collection('quizes').doc(Provider.of<UserDetails>(context,listen: false).currentClassCode).collection('quiz').snapshots(),
                 builder: (context,snapshot){
                   if(!snapshot.hasData){
                     return Center(
                       child: CircularProgressIndicator(
                         backgroundColor: Colors.indigo,
                       ),
                     );
                   }
                   if(snapshot.hasError)
                     {
                       return Center(
                         child: Text('Server error'),
                       );
                     }
                   final quizDetails = snapshot.data.docs;
                   for(var qd in quizDetails)
                   {
                     quizcards.add(buildTile(qd.data()['title'], qd.data()['date'], qd.data()['time'], qd.data()['type'],qd.id,qd.data()['imageUrl']));
                   }

                   return LayoutBuilder(
                     builder: (context,constraints)
                     {
                       if(constraints.maxWidth<839)
                         {
                           return SmallQuizScreen(quizcards);
                         }
                       else{
                         return LargeQuizScreen(quizcards);
                       }
                     },
                   );
                 },
               )

              ],
            ),
          ),

          widget.participantStatus=='Teacher'?
          Padding(
            padding: EdgeInsets.only(bottom: 30.0,right: 28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: FractionalOffset.bottomRight,
                  child:  FoldableOption(
                    icon1: Icons.create,
                    onTap1: (){
                      Navigator.push(context, FadeRoute(page: CreateMcqs()));
                    },
                    icon2: Icons.file_upload,
                    onTap2: (){
                      Navigator.push(context, FadeRoute(page:TeacherUploadQuiz(participantStatus: widget.participantStatus,)));
                    },

                  ),
                ),
              ],
            ),
          ): Container()

        ]
    );
  }
}
