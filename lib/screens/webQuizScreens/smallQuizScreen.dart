import 'package:flutter/material.dart';
import 'package:pardon_us/components/quiz_card.dart';

class SmallQuizScreen extends StatefulWidget {
  List<ListTile> quizCard;
  SmallQuizScreen(this.quizCard);
  @override
  _SmallQuizScreenState createState() => _SmallQuizScreenState();
}

class _SmallQuizScreenState extends State<SmallQuizScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.quizCard.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.quizCard,
    );
  }
}
