import 'package:flutter/material.dart';

class LargeQuizScreen extends StatefulWidget {
  List<ListTile> quizCard;
  LargeQuizScreen(this.quizCard);
  @override
  _LargeQuizScreenState createState() => _LargeQuizScreenState();
}

class _LargeQuizScreenState extends State<LargeQuizScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.quizCard.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: widget.quizCard,

        ),
      ],
    );
  }
}
