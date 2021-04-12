import 'dart:async';
import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet/room_name_constraint.dart';
import 'package:jitsi_meet/room_name_constraint_type.dart';
import 'package:pardon_us/models/userDeatils.dart';
//import 'package:pardon_us/screens/CallPage2.dart';
import 'package:pardon_us/screens/callPage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'utils/settings.dart';

class MeetingScreen extends StatefulWidget {
  @override
  _MeetingScreenState createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  final serverText = TextEditingController();
  final _channelController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _validateError = false;
  var isAudioOnly = true;
  var isAudioMuted = true;
  var isVideoMuted = true;
  bool meetingStarted = false;
  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  @override
  void initState() {
    super.initState();
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 13.0),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: JitsiMeetConferencing(
                extraJS: [
                  // extraJs setup example
                  '<script>function echo(){console.log("echo!!!")};</script>',
                  '<script src="https://code.jquery.com/jquery-3.5.1.slim.js" integrity="sha256-DrT5NfxfbHvMHux31Lkhxg42LY6of8TaYyK50jnxRnM=" crossorigin="anonymous"></script>'
                ],
              ),
            ),
            Provider.of<UserDetails>(context, listen: false)
                        .UserParticipantStatus ==
                    "Teacher"
                ? Text(
                    'By Pressing this Button you can create a new meeting.',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[100]),
                    textAlign: TextAlign.center,
                  )
                : Text(
                    'By Pressing this Button you can join a new meeting.',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[100]),
                    textAlign: TextAlign.center,
                  ),
            SizedBox(
              height: 10.0,
            ),
            RaisedButton(
              child: Provider.of<UserDetails>(context, listen: false)
                          .UserParticipantStatus ==
                      "Teacher"
                  ? Text('Start Meeting')
                  : Text('Join Meeting'),
              color: Colors.indigo,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0)),
              onPressed: () async {
                print('Start meeting pressed pressed');
                _joinMeeting();
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            SizedBox(
              height: 30.0,
              child: Divider(
                color: Colors.black26,
              ),
              width: 300.0,
            ),
            SizedBox(
              height: 20.0,
            ),
            ListTile(
              leading: Image.asset('images/csv.png'),
              title: Text('Attendance Report'),
              subtitle: Text('Date:- 20/12/2010 Time:- 40:00 min'),
            )
          ],
        ),
      ),
    );
  }

  _onAudioOnlyChanged(bool value) {
    setState(() {
      isAudioOnly = value;
    });
  }

  _onAudioMutedChanged(bool value) {
    setState(() {
      isAudioMuted = value;
    });
  }

  _onVideoMutedChanged(bool value) {
    setState(() {
      isVideoMuted = value;
    });
  }

  _joinMeeting() async {
    String serverUrl =
        serverText.text?.trim()?.isEmpty ?? "" ? null : serverText.text;

    // Enable or disable any feature flag here
    // If feature flag are not provided, default values will be used
    // Full list of feature flags (and defaults) available in the README
    Map<FeatureFlagEnum, bool> featureFlags = {
      FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
    };
    if (!kIsWeb) {
      //Here is an example, disabling features for each platform
      // if (Platform.isAndroid) {
      //   // Disable ConnectionService usage on Android to avoid issues (see README)
      //   featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      // } else if (Platform.isIOS) {
      //   // Disable PIP on iOS as it looks weird
      //   featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      // }
    }
    // Define meetings options here
    var options = JitsiMeetingOptions()
      ..room = Provider.of<UserDetails>(context, listen: false).currentClassCode
      ..serverURL = serverUrl
      ..subject = 'Classroom meeting'
      ..userDisplayName =
          Provider.of<UserDetails>(context, listen: false).username
      ..userEmail = Provider.of<UserDetails>(context, listen: false).Useremail
      ..iosAppBarRGBAColor = '#0080FF80'
      ..audioOnly = isAudioOnly
      ..audioMuted = isAudioMuted
      ..videoMuted = isVideoMuted
      ..featureFlags.addAll(featureFlags)
      ..webOptions = {
        "roomName":
            Provider.of<UserDetails>(context, listen: false).currentClassCode,
        "width": "100%",
        "height": "100%",
        "enableWelcomePage": false,
        "chromeExtensionBanner": null,
        "userInfo": {
          "displayName":
              Provider.of<UserDetails>(context, listen: false).username
        }
      };

    debugPrint("JitsiMeetingOptions: $options");
    await JitsiMeet.joinMeeting(
      options,
      listener: JitsiMeetingListener(
          onConferenceWillJoin: ({message}) {
            debugPrint("${options.room} will join with message: $message");
          },
          onConferenceJoined: ({message}) {
            debugPrint("${options.room} joined with message: $message");
          },
          onConferenceTerminated: ({message}) {
            debugPrint("${options.room} terminated with message: $message");
          },
          genericListeners: [
            JitsiGenericListener(
                eventName: 'readyToClose',
                callback: (dynamic message) {
                  debugPrint("readyToClose callback");
                }),
          ]),
    );
  }

  static final Map<RoomNameConstraintType, RoomNameConstraint>
      customContraints = {
    RoomNameConstraintType.MAX_LENGTH: new RoomNameConstraint((value) {
      return value.trim().length <= 50;
    }, "Maximum room name length should be 30."),
    RoomNameConstraintType.FORBIDDEN_CHARS: new RoomNameConstraint((value) {
      return RegExp(r"[$€£]+", caseSensitive: false, multiLine: false)
              .hasMatch(value) ==
          false;
    }, "Currencies characters aren't allowed in room names."),
  };

  void _onConferenceWillJoin({message}) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined({message}) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated({message}) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }
}
