import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pardon_us/components/alertBox.dart';
import 'package:pardon_us/models/userDeatils.dart';
import 'package:pardon_us/screens/assignments_screens/studentAssignmentAttemptList.dart';
import 'package:pardon_us/screens/assignments_screens/student_assignment_upload.dart';
import 'package:pardon_us/animation_transition/fade_transition.dart';
import 'package:pardon_us/models/assignmentModel.dart';
import 'package:provider/provider.dart';

class AssignmentCard extends StatefulWidget {
  String assignmentTitle, dueTime, dueDate, docId;
  String participantStatus, fileUrl;
  bool lock;

  AssignmentCard(this.participantStatus, this.assignmentTitle, this.dueDate,
      this.dueTime, this.fileUrl, this.docId, this.lock);
  @override
  _AssignmentCardState createState() => _AssignmentCardState();
}

class _AssignmentCardState extends State<AssignmentCard> {
  MediaQueryData queryData;
  AssignmentModel assignmentModel;
  String marksObtained = '0';
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  getStudentMarks() async {
    final user = await _firestore
        .collection('assignments')
        .doc(Provider.of<UserDetails>(context, listen: false).currentClassCode)
        .collection('assignment')
        .doc(widget.docId)
        .collection('attemptedBy')
        .where('name',
            isEqualTo:
                Provider.of<UserDetails>(context, listen: false).username)
        .get();
    for (var data in user.docs) {
      if (data.id != null) {
        setState(() {
          marksObtained = data.data()['marksObtained'];
        });
      } else {
        break;
      }
    }
  }

  Future<bool> checkAttempt(
      String assDocID, String dueDate, String dueTime) async {
    String id;
    try {
      DateTime due = DateTime.parse(dueDate);
      final check = due.compareTo(DateTime.now());
      final time = TimeOfDay.now();
      var now = DateTime.now();
      int mDiff = due.month - now.month;
      int yDiff = due.year - now.year;
      int dDiff = due.day - now.day;
      print("$mDiff $yDiff $dDiff");
      bool attempted;
      final user = await _firestore
          .collection('assignments')
          .doc(
              Provider.of<UserDetails>(context, listen: false).currentClassCode)
          .collection('assignment')
          .doc(assDocID)
          .collection('attemptedBy')
          .where('name',
              isEqualTo:
                  Provider.of<UserDetails>(context, listen: false).username)
          .get();
      for (var data in user.docs) {
        id = data.id;
      }
      if (id != null) {
        attempted = true;
      } else {
        attempted = false;
      }
      if (dDiff >= 0 && mDiff >= 0 && yDiff >= 0 && !attempted) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.participantStatus == 'Student') {
      getStudentMarks();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return GestureDetector(
      child: Card(
        elevation: 3.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          height: 150.0,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('images/assignmentCard.jpg'),
                radius: 40.0,
              ),
              title: Text(
                widget.assignmentTitle,
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
                  SizedBox(
                    height: 10.0,
                  ),
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
              trailing: widget.participantStatus == 'Student'
                  ? Column(
                      children: [
                        Expanded(
                          child: AutoSizeText(
                            'Marks\nObtained',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 14.0,
                            ),
                            textAlign: TextAlign.center,
                            minFontSize: 6.0,
                          ),
                        ),
                        Expanded(
                          child: AutoSizeText(
                            '$marksObtained',
                            style:
                                TextStyle(color: Colors.green, fontSize: 16.0),
                            minFontSize: 7.0,
                          ),
                        )
                      ],
                    )
                  : Text(' ')),
        ),
      ),
      onTap: () async {
        AlertBoxes _alert = AlertBoxes();
        DateTime dueDate = DateTime.parse(widget.dueDate);
        int checkLock = dueDate.compareTo(DateTime.now());
        final time = TimeOfDay.now();

        bool check =
            await checkAttempt(widget.docId, widget.dueDate, widget.dueTime);
        print(widget.participantStatus);
        if (widget.participantStatus == 'Student') {
          if (check) {
            print(widget.docId);
            assignmentModel = AssignmentModel();
            assignmentModel.setAssignmentDetails(
                title: widget.assignmentTitle,
                time: widget.dueTime,
                date: widget.dueDate,
                fileUrl: widget.fileUrl,
                docId: widget.docId);
            Navigator.push(
                context,
                FadeRoute(
                    page: StudentUploadAssignment(
                  assDetails: assignmentModel,
                )));
          } else {
            _alert.simpleAlertBox(
                context,
                Text('Assignment Locked'),
                Text(
                    'Either you have attempted the assignment or due time is over.'),
                () {
              Navigator.pop(context);
            });
          }
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StudentAssignmentAttemptList(
                        assDocId: widget.docId,
                      )));
        }
      },
    );
  }
}
