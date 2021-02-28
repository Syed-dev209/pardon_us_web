import 'package:flutter/material.dart';

class SmallAssignmentScreen extends StatefulWidget {
  List<ListTile> assignmentCards;
  SmallAssignmentScreen(this.assignmentCards);
  @override
  _SmallAssignmentScreenState createState() => _SmallAssignmentScreenState();
}

class _SmallAssignmentScreenState extends State<SmallAssignmentScreen> {
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.assignmentCards.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children:widget.assignmentCards,
    );
  }
}
