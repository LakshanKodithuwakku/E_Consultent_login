import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:econsultent/pages/Home.dart';
import 'package:econsultent/pages/videochat/index.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

var Token;
String channel = '';
String startTime = '';
String endTime = '';
String meetingDate = '';

class Server extends StatefulWidget {
  @override
  _ServerState createState() => _ServerState();
}

// class Token {
//   final String channel;

//   Token({this.channel});

//   factory Token.fromJson(Map<String, dynamic> json) {
//     return Token(channel: json['channel']);
//   }
// }

class _ServerState extends State<Server> {
  final mainRef = FirebaseDatabase.instance;
  Map data;
  List UsersData;
  Map token;

  final channelController = TextEditingController();
  final _fromKey = GlobalKey<FormState>();

  // getUsers() async {
  //   http.Response response = await http.get('http://10.0.2.2:4000/api/users');
  //   data = json.decode(response.body);
  //   setState(() {
  //     UsersData = data['users'];
  //   });
  // }

  Map<String, String> headers = {'content-type': 'application/json'};

  Future<void> getToken(String cname, String eTime, String mDate) async {
    http.Response response = await http.post('http://10.0.2.2:3000/rtcToken',
        headers: headers,
        body: '{"channel":"${cname}","eTime":"${eTime}","mDate":"${mDate}"}');
    token = json.decode(response.body);

    setState(() {
      Token = token['token'];
    });
    print(Token);
    // print(token['expireTimeMinute']);
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    // getUserID();
  }

/*
  //----------------------get the current user id
  FirebaseUser user;
  String id;
  Future<void> getUserID() async {
    final FirebaseUser userData = await FirebaseAuth.instance.currentUser();
    setState(() {
      user = userData;
      id = userData.uid.toString();
      print(userData.uid);
    });
  }

  //-------------------------------------------------

  //-----------------rtm chat
  Map rtmToken;
  var mToken;
  Future<void> getRTMtoken(String uid, String eTime, String mDate) async {
    //method to get RTM token
    http.Response response = await http.post('http://10.0.2.2:3000/rtmToken',
        headers: headers,
        body: '{"user":"${uid}","eTime":"${eTime}","mDate":"${mDate}"}');
    rtmToken = json.decode(response.body);

    setState(() {
      mToken = rtmToken['key'];
    });
    print(mToken);
  }
  //---------------------------
*/
  Future<void> sendDatabse() async {
    final ref = mainRef.reference().child('Meeting').child('$channel');
    ref.child('token').set(Token);
    //  ref.child('$id').child('rtmToken').set(mToken);
  }

  //snackBar
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<void> _showSnackBar() async {
    final snackBar = new SnackBar(
        content: new Text(
          "Sucessfully created the meeting",
          textAlign: TextAlign.center,
        ),
        duration: new Duration(seconds: 3),
        backgroundColor: Colors.blueAccent);
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: FlatButton(
            onPressed: () => {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return HomePage();
                  }))
                },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        title: Text('Create a Meeting'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTile(
                  trailing: FlatButton(
                      color: Colors.lightBlue,
                      onPressed: () => {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) {
                              return IndexPage();
                            }))
                          },
                      child: Text(
                        'Join Meeting',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Container(
                  height: 340.0,
                  decoration: BoxDecoration(color: Colors.blue[100]),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                        key: _fromKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                  hintText: 'Enter unique meeting name'),
                              validator: (text) {
                                if (text.isEmpty) {
                                  return 'channel name must be enter';
                                }
                                return null;
                              },
                              onChanged: (String value) {
                                channel = value;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  hintText: 'Enter meeting date MM DD YYYY'),
                              validator: (text) {
                                if (text.isEmpty) {
                                  return 'Date must be enter here';
                                }
                                return null;
                              },
                              onChanged: (String value) {
                                meetingDate = value;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  hintText: 'Enter Start Time Here HH:MM'),
                              onChanged: (String value) {
                                startTime = value;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  hintText: 'Enter End Time Here HH:MM'),
                              onChanged: (String value) {
                                endTime = value;
                              },
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            RaisedButton(
                              color: Colors.blue,
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              onPressed: () async {
                                if (_fromKey.currentState.validate()) {
                                  _fromKey.currentState.save();
                                  print(channel);
                                  await getToken(channel, endTime, meetingDate);
                                  //      await getRTMtoken(id, endTime, meetingDate);
                                  await sendDatabse();
                                  await _showSnackBar();
                                }
                              },
                              child: Text("Submit",
                                  style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 2.0,
                                      color: Colors.white)),
                            ),

                            /*     FlatButton(
                                    onPressed: () {
                                      retrieveDatabse();
                                    },
                                    child: Text(
                                      'retrieve',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18.0),
                                    )) */
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // body: Center(
      //   child: Container(
      //     child: Column(
      //       children: [
      //         Padding(
      //           padding: const EdgeInsets.all(8.0),
      //           child: TextField(
      //             controller: channelController,
      //           ),
      //         ),
      //         FlatButton(
      //             color: Colors.amber,
      //             onPressed: () => {
      //                   getToken(channelController.text),
      //                   print(channelController.text)
      //                 },
      //             child: Text('Save')),
      //       ],
      //     ),
      //   ),
      // )
      // body: ListView.builder(
      //     itemCount: UsersData == null ? 0 : UsersData.length,
      //     itemBuilder: (BuildContext context, int index) {
      //       return Card(
      //         child: Row(
      //           children: [
      //             CircleAvatar(
      //               backgroundImage: NetworkImage(UsersData[index]['avatar']),
      //             )
      //           ],
      //         ),
      //       );
      //     }));
    );
  }
}
