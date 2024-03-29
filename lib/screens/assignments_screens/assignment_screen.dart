import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pardon_us/animation_transition/fade_transition.dart';
import 'package:pardon_us/components/assignmnet_card.dart';
import 'package:pardon_us/components/quiz_card.dart';
import 'package:pardon_us/models/assignmentModel.dart';
import 'package:pardon_us/models/userDeatils.dart';
import 'package:pardon_us/screens/assignments_screens/teacher_assignment_upload.dart';
import 'package:pardon_us/screens/webAssignmentScreens/largeAssignmentScreen.dart';
import 'package:pardon_us/screens/webAssignmentScreens/smallAssignmentScreen.dart';
import 'package:provider/provider.dart';

class AssignmentScreen extends StatefulWidget {
  String participantStatus;
  AssignmentScreen({this.participantStatus});
  @override
  _AssignmentScreenState createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  FirebaseFirestore _firestore;
  List<ListTile> assignmentCards = [];
  bool attempt;
  Widget buildStudentTile(
      String title, String date, String time, String url, String id) {
    lockQuiz(id, date);
    return ListTile(
      title: AssignmentCard('Student', title, date, time, url, id, attempt),
    );
  }

  Widget buildTeacherTile(
      String title, String date, String time, String url, String id) {
    return ListTile(
      title: AssignmentCard('Teacher', title, date, time, url, id, false),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firestore = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.participantStatus);
    return Stack(children: [
      Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: [
            widget.participantStatus == 'Teacher'
                ? StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('assignments')
                        .doc(Provider.of<UserDetails>(context, listen: false)
                            .currentClassCode)
                        .collection('assignment')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.indigo,
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error while loading assignments'),
                        );
                      }
                      final assDetails = snapshot.data.docs;
                      for (var ad in assDetails) {
                        String title = ad.data()['title'];
                        String date = ad.data()['date'];
                        String time = ad.data()['time'];
                        String url = ad.data()['imageUrl'];
                        assignmentCards.add(
                            buildTeacherTile(title, date, time, url, ad.id));
                      }

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: assignmentCards.isNotEmpty
                            ? assignmentCards
                            : [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: Text(
                                      'You have\'nt created any Assignment yet.',
                                      style: TextStyle(
                                          fontSize: 30.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.indigo[100]),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              ],
                      );
                    },
                  )
                :
                // QuizCard('Students list attempted assignmnets','Date','Time','Mcqs','Show Participants',"",""),
                StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('assignments')
                        .doc(Provider.of<UserDetails>(context, listen: false)
                            .currentClassCode)
                        .collection('assignment')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.indigo,
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error while loading assignments'),
                        );
                      }
                      final assDetails = snapshot.data.docs;
                      for (var ad in assDetails) {
                        String title = ad.data()['title'];
                        String date = ad.data()['date'];
                        String time = ad.data()['time'];
                        String url = ad.data()['imageUrl'];
                        assignmentCards.add(
                            buildStudentTile(title, date, time, url, ad.id));
                      }

                      return assignmentCards.isNotEmpty
                          ? LayoutBuilder(
                              builder: (context, constraints) {
                                if (constraints.maxWidth < 839) {
                                  return SmallAssignmentScreen(assignmentCards);
                                } else {
                                  return LargeAssignmentScreen(assignmentCards);
                                }
                              },
                            )
                          : Container(
                              height: MediaQuery.of(context).size.height * 0.7,
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Text(
                                  'You  Instructor has\'nt created any Assignment yet.',
                                  style: TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo[100]),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                    },
                  )
          ],
        ),
      ),
      // Column(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      // crossAxisAlignment: CrossAxisAlignment.end,
      // children:assignmentCards,
      // );

      widget.participantStatus == 'Teacher'
          ? Padding(
              padding: EdgeInsets.only(bottom: 70.0, right: 28.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                      alignment: FractionalOffset.bottomRight,
                      child: GestureDetector(
                        child: Container(
                          height: 60.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                              color: Colors.indigo,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                          child: Icon(
                            Icons.file_upload,
                            size: 27,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context,
                              FadeRoute(page: TeacherUploadAssignment()));
                        },
                      )),
                ],
              ),
            )
          : Container()
    ]);
  }

  void lockQuiz(String quizDocID, String dueDate) async {
    bool check = await checkAttempt(quizDocID, dueDate);
    attempt = check;
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
            .collection('assignments')
            .doc(Provider.of<UserDetails>(context, listen: false)
                .currentClassCode)
            .collection('assignment')
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
          print('exist');
          return true;
        } else {
          print('not exist');
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }
}
