import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:econsultent/pages/Home.dart';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_storage/firebase_storage.dart';
//import 'package:path/path.dart' as path;

import 'package:firebase_auth/firebase_auth.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

String a;
class _EditProfileState extends State<EditProfile> {
  TextEditingController _nameController;

  File _image;
  String _name, _password;
  String name="",proPic="",password;

  DatabaseReference _ref;
  @override
  void initState() {
    super.initState( );
    _nameController = TextEditingController();
   // getData();
    getUserID();
    getUserDetails();
  }

 /* //-------init function can not make as asynchronous function
  Future<void> getData() async {
      await getUserID();
      await getUserDetails();
  }
  //-----------------------------------------------*/

  //--------------------Retrive user id from firebase
  FirebaseUser user;
  String id;
  Future<void> getUserID() async {
    final FirebaseUser userData = await FirebaseAuth.instance.currentUser();
    setState(() {
      user = userData;
      id = userData.uid.toString();
     // password = user.pa.toString();
      print(userData.uid);
    });
  }
//------------------------------------------------------

  /// *******************************************************
  /// GET USER DETAILS
  /// *******************************************************
  Future<void> getUserDetails( ) async{
    await getUserID();
    _ref = FirebaseDatabase.instance.reference( ).child( 'general_user' );
    DataSnapshot snapshot = await _ref.child("$id").once();
    Map general_user = snapshot.value;
    _nameController.text = general_user['name'];
    name = general_user['name'];
    print(name);
    proPic = general_user['proPicURL'];
    print(proPic);
  }
  /// *****************GET USER DETAILS********************

  /// ******************************************************
  /// SEND TO DATABASE
  /// ******************************************************
  final FirebaseDatabase database = FirebaseDatabase.instance;
  void _userUpdate(){
    database.reference().child("general_user").
    child("${user.uid}").update({
      "email" : "${user.email}",
      "name" : _name,
    });

    setState(() {
      database.reference().child("general_user").once().then((DataSnapshot snapshot){
        Map<dynamic, dynamic> data = snapshot.value;
        print("Value: $data");
      });
    });
  }
  /// ****************SEND TO DATABASE*****************

  /// *****************************************
  /// Page Body
  /// *****************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(title: Text("Edit Profile"),centerTitle: true,
          leading: IconButton(
            icon: Icon(
                Icons.arrow_back
            ),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
            },
          ),),

        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Container(
            child: Column(

              children: <Widget>[
                SizedBox(
                  height: 70.0,
                ),
                imageProfile( ),
                SizedBox(
                  height: 20,
                ),

                Container(

                  child: Form(

                    child: Column(

                      children: <Widget>[
                        displayName(),
                        SizedBox( height: 20 ),
                        currentPassword(),
                        SizedBox( height: 20 ),
                        newPassword(),
                        SizedBox( height: 20 ),
                        conformNewPassword(),
                        SizedBox( height: 70 ),

                        Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CancelButton(),
                            SizedBox(width: 20,),
                            SaveButton(),
                          ],
                        )

                      ],
                    ),

                  ),
                ),
              ],
            ),
          ),
        )

    );

  }

  /// *****************************************
  /// current Name
  /// *****************************************
  Widget displayName(){
    return Container(
      child: TextFormField(
        controller: _nameController,
        validator: (input) {
          if (input.isEmpty) {
            return 'Enter Name';
          }else if(input.length<4){
            return 'Username should be grater than or equel 4';
          }
        },

        decoration: InputDecoration(
         // labelText: "Name: "+ name,//"${user.displayName}",
          hintText: 'Enter new name',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0)
          ),
          prefixIcon: Icon( Icons.person ),
        ),

        onChanged: (val) {
          _name = val;
        },

      ),
    );
  }
  /// ***********current name**************

  /// *****************************************
  /// current Password
  /// *****************************************
  Widget currentPassword(){
    return Container(

      child: TextFormField(

          validator: (input) {
            if (input.length < 6)
              return 'Provide Minimum 6 Character';
          },

          decoration: InputDecoration(
            labelText:// 'Current Password'+
             password,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0)
            ),
            prefixIcon: Icon( Icons.lock ),
          ),
          obscureText: true,

          onChanged: (val) {
            _password = val;
          }
      ),
    );
  }
  /// *********current Password***************

  /// *****************************************
  /// New Password
  /// *****************************************
  Widget newPassword(){
    return Container(

      child: TextFormField(

          validator: (input) {
            if (input.length < 6)
              return 'Provide Minimum 6 Character';
          },

          decoration: InputDecoration(
            labelText: 'Create New Password',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0)
            ),
            prefixIcon: Icon( Icons.lock ),
          ),
          obscureText: true,

          onChanged: (val) {
            _password = val;
          }
      ),
    );
  }
  /// *********New Password***************

  /// *****************************************
  /// Conform New Password
  /// *****************************************
  Widget conformNewPassword(){
    return Container(

      child: TextFormField(

          validator: (input) {
            if (input.length < 6)
              return 'Provide Minimum 6 Character';
          },

          decoration: InputDecoration(
            labelText: 'Conform New Password',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0)
            ),
            prefixIcon: Icon( Icons.lock ),
          ),
          obscureText: true,

          onChanged: (val) {
            _password = val;
          }
      ),
    );
  }
  /// *********Conform New Password***************

  /// *****************************************
  /// Save Button
  /// *****************************************
  Widget SaveButton(){
    return FlatButton(
      padding: EdgeInsets.only(left:45,right:45),

      onPressed: (){
        _userUpdate();
        Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
      },
      child: Text( 'SAVE', style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold
      )
      ),
      color: Colors.blueAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular( 20.0 ),
      ),
    );
  }

  /// *****************************************
  /// Cancel Button
  /// *****************************************
  Widget CancelButton(){
   return FlatButton(
      padding: EdgeInsets.only(left:35,right:35),
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
      },
      child: Text( 'CANCEL', style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold
      )
      ),
      color: Colors.blueAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular( 20.0 ),
      ),
    );
  }

  /// *****************************************
  /// Profile Pic
  /// *****************************************
  Widget imageProfile() {
    return Stack(
      children: <Widget>[
        CircleAvatar(
          radius: 80.0,
          backgroundImage: proPic == ""
              ? AssetImage( "images/avatar.png" )
              : NetworkImage(proPic),
        //  FileImage( File( _image.path ) ),
        ),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet( )),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.black38,
              size: 28.0,
            ),
          ),
        ),
      ],
    );
  }

  /// *****************************************
  /// Image select method popup
  /// *****************************************
  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery
          .of( context )
          .size
          .width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column( children: <Widget>[
        Text( "Choose Profile photo",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
              icon: Icon( Icons.camera ),
              onPressed: () {
                takePhoto( ImageSource.camera );
              },
              label: Text( "Camera" ),
            ),
            FlatButton.icon(
              icon: Icon( Icons.image ),
              onPressed: () {
                takePhoto( ImageSource.gallery );
              },
              label: Text( "Gallery" ),
            ),
          ],
        )
      ],
      ),
    );
  }

  /// *****************************************
  /// Image Picker method
  /// *****************************************
  void takePhoto(ImageSource source) async {
    var image = await ImagePicker.pickImage(
      source: source,
    );
    setState( () {
      _image = image;
      //_pathImg = path.basename(_image.path);
    } );
  }

}