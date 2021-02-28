import 'package:flutter/material.dart';
import 'package:pardon_us/components/drawer_item.dart';
import 'package:pardon_us/models/userDeatils.dart';
import 'package:pardon_us/screens/assignments_screens/assignment_screen.dart';
import 'package:pardon_us/screens/meetingScreen.dart';
import 'package:pardon_us/screens/message_screen.dart';
import 'package:pardon_us/screens/participants.dart';
import 'package:pardon_us/screens/quiz_screens/quiz_screen.dart';
import 'package:provider/provider.dart';

class SmallClassScreen extends StatefulWidget {
  @override
  _SmallClassScreenState createState() => _SmallClassScreenState();
}

class _SmallClassScreenState extends State<SmallClassScreen> {
  String name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF303F9F),
        // leading: Icon(Icons.list),
        title: Text('PARDON US'),
        bottom: TabBar(
          tabs: [
            Tab(icon:Icon(Icons.question_answer),text: 'Messages' ),
            Tab(icon:Icon(Icons.error_outline),text: 'Quiz'),
            Tab(icon:Icon(Icons.assignment_late),text: 'Assignment'),
            Tab(icon: Icon(Icons.video_call),text:'Meetings',)
          ],

        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_pin,color: Colors.white,)
            ,iconSize: 32.0,
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context)=>Participants()
              ));
            },
          )
        ],
      ),
      drawer:DrawerItem(),
      body: SafeArea(
          child: Consumer<UserDetails>(
            builder: (context,user,child){
              name=user.username;
              return TabBarView(
                children: [
                  MessagesScreen(classCode: user.currentClassCode,username: user.username),
                  QuizScreen(participantStatus: user.UserParticipantStatus),
                  AssignmentScreen(participantStatus: user.UserParticipantStatus),
                  MeetingScreen()
                ],
              );
            },
          )
      ),
    );
  }
}
