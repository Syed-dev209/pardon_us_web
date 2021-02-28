import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pardon_us/animation_transition/scale_transition.dart';
import 'package:pardon_us/models/connectivity.dart';
import 'package:pardon_us/models/login_methods.dart';
import 'package:pardon_us/models/userDeatils.dart';
import 'package:pardon_us/screens/register_user.dart';
import 'package:pardon_us/screens/start_screen.dart';
import 'package:pardon_us/screens/webScreens/logInAndRegister/logInSmall.dart';
import 'package:pardon_us/screens/webScreens/logInAndRegister/loginlarge.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:provider/provider.dart';
import 'webScreens/logInAndRegister/web_register_user.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _key=GlobalKey<FormState>();
  MediaQueryData queryData;
  ScaleRoute route;
  bool showSpinner=false,isLoggedIn=false;
  LogInMethods _login;
  final emailController = TextEditingController();
  final passController= TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String email,name,imageURl,uid;

  Future<void> getUser(String checkEmail)async {
   final user = await _firestore.collection('user').where('email',isEqualTo: checkEmail).get();
   for(var data in user.docs)
     {
       email=data.data()['email'];
       name=data.data()['name'];
       imageURl=data.data()['profile'];
       uid=data.id;
     }
   print('at log in page:- '+email+name+imageURl+uid);
  }
  @override
  void dispose() {
    emailController.clear();
    passController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      Future<bool> onWillPop() {
        return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Confirm Exit?',
                style: new TextStyle(color: Colors.black, fontSize: 20.0)),
            content: new Text(
                'Are you sure you want to exit the app? Tap \'Yes\' to exit \'No\' to cancel.'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  // this line exits the app.
                  SystemChannels.platform
                      .invokeMethod('SystemNavigator.pop');
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
    queryData=MediaQuery.of(context);
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SafeArea(
            child: Container(
              height: queryData.size.height,
              width: queryData.size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/blueBf.png'),
                    fit: BoxFit.fill
                )
              ),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints){
                  if(constraints.maxWidth<839)
                    {return SmallPage();}
                  else{
                    return LargePage();
                  }
                },
              )
            ),
          ),
        ),
      ),
      onWillPop: onWillPop,
    );
  }
}








