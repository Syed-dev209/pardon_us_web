import 'package:flutter/material.dart';
import 'package:pardon_us/animation_transition/scale_transition.dart';
import 'package:pardon_us/screens/start_screen.dart';
import 'package:pardon_us/screens/webClassScreens/smallClassScreen.dart';
import 'package:pardon_us/screens/webClassScreens/largeClassScreen.dart';

class ClassScreen extends StatefulWidget {

  @override
  _ClassScreenState createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  String name;
  Future<bool> onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Confirm Exit?',
            style: new TextStyle(color: Colors.black, fontSize: 20.0)),
        content: new Text(
            'Do you wish to exit this class?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              //Provider.of<UserDetails>(context,listen: false).setUserClassStatus(null, null);
              Navigator.push(context, ScaleRoute(page:Start()));
            },
            child:
            new Text('Yes', style: new TextStyle(fontSize: 18.0)),
          ),
          new FlatButton(
            onPressed: () => Navigator.pop(context), // this line dismisses the dialog
            child: new Text('No', style: new TextStyle(fontSize: 18.0)),
          )
        ],
      ),
    ) ??
        false;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: DefaultTabController(
        length: 4,
        child: LayoutBuilder(
          builder: (context,constraints)
          {
            if(constraints.maxWidth<839){
              return SmallClassScreen();
            }
            else
              {
                return LargeClassScreen();
              }
          },
        )
      ),
      onWillPop: onWillPop,
    );
  }
}
