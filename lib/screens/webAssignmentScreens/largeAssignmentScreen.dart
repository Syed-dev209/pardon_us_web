import 'package:flutter/material.dart';

class LargeAssignmentScreen extends StatefulWidget {
  List<ListTile> assignmentCards;
  LargeAssignmentScreen(this.assignmentCards);
  @override
  _LargeAssignmentScreenState createState() => _LargeAssignmentScreenState();
}

class _LargeAssignmentScreenState extends State<LargeAssignmentScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.assignmentCards.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: widget.assignmentCards,
        ),
      ],
    );
  }
}
