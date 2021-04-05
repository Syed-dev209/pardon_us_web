import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pardon_us/components/alertBox.dart';
import 'package:pardon_us/models/create_Mcqs_Model.dart';
import 'package:pardon_us/screens/quiz_screens/mcqs_attempt_screen.dart';
import 'package:pardon_us/animation_transition/fade_transition.dart';
import 'package:pardon_us/screens/quiz_screens/studentQuizAttemptList.dart';
import 'package:pardon_us/screens/quiz_screens/student_uplod_quiz-screen.dart';
import 'package:pardon_us/screens/quiz_screens/mcqs_create_screen.dart';
import 'package:pardon_us/screens/quiz_screens/teacher_upload_quiz_screen.dart';
import 'package:pardon_us/screens/participants.dart';
import 'package:provider/provider.dart';

import '../models/userDeatils.dart';


class QuizCard extends StatefulWidget {
  String quizTitle,dueTime,dueDate;
  String filestatus,participantStatus,docId,imgUrl;
  bool lock;
  QuizCard(this.quizTitle,this.dueDate,this.dueTime,this.filestatus,this.participantStatus,this.docId,this.imgUrl,this.lock);
  @override
  _QuizCardState createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
  MediaQueryData queryData;
  bool attempt=false;
  String marksObtained='0';
  FirebaseFirestore _firestore=FirebaseFirestore.instance;
  void lockQuiz(String quizDocID, String dueDate) async {
    bool check = await checkAttempt(quizDocID, dueDate);
    print(check);
    setState(() {
      attempt=check;
    });
  }
  getStudentMarks() async {
    final user = await _firestore
        .collection('quizes')
        .doc(Provider.of<UserDetails>(context, listen: false).currentClassCode)
        .collection('quiz')
        .doc(widget.docId)
        .collection('attemptedBy')
        .where('name',
        isEqualTo:
        Provider.of<UserDetails>(context, listen: false).username)
        .get();
    for (var data in user.docs) {
      if (data.id != null) {
        marksObtained = data.data()['marksObtained'];
      } else {
        break;
      }
    }
  }

  Future<bool> checkAttempt(String quizDocID, String dueDate) async {
    String id;
    try {
      DateTime due = DateTime.parse(dueDate);
      final check = due.compareTo(DateTime.now());
      if (check >= 0) {
        return true;
      } else {
        final user = await _firestore
            .collection('quizes')
            .doc(Provider.of<UserDetails>(context, listen: false)
            .currentClassCode)
            .collection('quiz')
            .doc(quizDocID)
            .collection('attemptedBy')
            .where('name',
            isEqualTo:
            Provider.of<UserDetails>(context, listen: false).username)
            .get();
        for (var data in user.docs) {
          id = data.id;
        }
        if (id != null) {
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lockQuiz(widget.docId, widget.dueDate);
  }  @override
  Widget build(BuildContext context) {
    queryData=MediaQuery.of(context);
    return GestureDetector(
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
        ),
        child: Container(
          height: 150.0,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),

          ),
          child: ListTile(
              leading:CircleAvatar(
                backgroundImage: AssetImage('images./quizCard.jpg'),
                radius: 40.0,
              ),
              title: Text(
                widget.quizTitle,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 23.0,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 2.0,
                ),
                overflow: TextOverflow.fade,
                softWrap: false,
                maxLines: 1,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0,),
                  Text(
                    DateTime.parse(widget.dueDate)
                        .toLocal()
                        .toString()
                        .split(' ')[0],
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.dueTime,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              trailing: widget.participantStatus=='Student'? Column(
                children: [
                  Text('Marks\nObtained',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text('$marksObtained',style: TextStyle(
                      color: Colors.green,
                      fontSize: 16.0
                  ),)
                ],
              ):Text(' ')
          )
        ),
      ),
      onTap: (){
        if(!attempt||widget.participantStatus=='Teacher') {
          Provider.of<QuizModel>(context, listen: false).addQuizDetails(
              widget.quizTitle, widget.dueTime, widget.dueDate, widget.imgUrl);
          if (widget.filestatus == 'mcqs' &&
              widget.participantStatus == 'Student') {
            Navigator.push(
                context, FadeRoute(page: AttemptMCQS(docId: widget.docId,)));
          }
          else if (widget.filestatus == 'mcqs' &&
              widget.participantStatus == 'Teacher') {
            Navigator.push(context, FadeRoute(page: StudentQuizList(quizDocId: widget.docId,)));
          }
          else if (widget.filestatus == 'file' &&
              widget.participantStatus == 'Student') {
            Navigator.push(context, FadeRoute(page: UploadQuiz(widget.docId)));
          }
          else if (widget.filestatus == 'file' &&
              widget.participantStatus == 'Teacher') {
            Navigator.push(context, FadeRoute(page: StudentQuizList(quizDocId: widget.docId,)));
          }
          // else {
          //   Navigator.push(context, FadeRoute(page: Participants()));
          // }
        }
        else{
          AlertBoxes _alert=AlertBoxes();
          _alert.simpleAlertBox(context, Text('Quiz Locked'), Text('Either you have attempted this quiz or due time is over.'), (){
            Navigator.pop(context);
          });
        }
      },
    );
  }
}
