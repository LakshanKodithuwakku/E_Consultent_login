import 'package:econsultent/pages/reset.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'SignUp.dart';
import 'package:econsultent/pages/Start.dart';
//import 'package:econsultent/pages/home_page.dart';
import 'package:econsultent/pages/Home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {


  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email, _password;

  checkAuthentification() async
  {

    _auth.onAuthStateChanged.listen((user) {

      if(user!= null)
      {
        print(user);

        Navigator.push(context, MaterialPageRoute(

            builder: (context)=>HomePage()));
      }

    });



  }
  @override
  void initState()
  {
    super.initState();
    this.checkAuthentification();
  }
  login()async
  {
    if(_formKey.currentState.validate())
    {

      _formKey.currentState.save();

      try{
        FirebaseUser user = (await _auth.signInWithEmailAndPassword(email: _email, password: _password)) as FirebaseUser;
      }

      catch(e)
      {
        showError(e.message);
        print(e);
      }

    }
  }

  showError(String errormessage){

    showDialog(

        context: context,
        builder: (BuildContext context)
        {
          return AlertDialog(

            title: Text('ERROR'),
            content: Text(errormessage),

            actions: <Widget>[
              FlatButton(

                  onPressed: (){
                    Navigator.of(context).pop();
                  },


                  child: Text('OK'))
            ],
          );
        }


    );

  }

  navigateToSignUp()async
  {

    Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUp()));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
                Icons.arrow_back
            ),
            onPressed:(){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Start()));
            }// navigateToStart(),
          ),),

        body: SingleChildScrollView(
          child: Container(

            child: Column(

              children: <Widget>[

                Container(

                  height: 400,
                  child: Image(image: AssetImage("images/login.jpg"),
                    fit: BoxFit.contain,
                  ),
                ),

                Container(

                  child: Form(

                    key: _formKey,
                    child: Column(

                      children: <Widget>[

                        Container(

                          child: TextFormField(

                              validator: (input)
                              {
                                if(input.isEmpty)

                                  return 'Enter Email';
                              },

                              decoration: InputDecoration(

                                  labelText: 'Email',
                                  prefixIcon:Icon(Icons.email)
                              ),

                              onSaved: (input) => _email = input


                          ),
                        ),

                        Container(
                          child: TextFormField(
                              validator: (input)
                              {
                                if(input.length < 6)
                                  return 'Provide Minimum 6 Character';
                              },
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon:Icon(Icons.lock),
                              ),
                              obscureText: true,
                              onSaved: (input) => _password = input
                          ),
                        ),
                        Container(
                          child: TextButton(child: Text('Forgot Password?'),onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResetScreen())),),
                        ),
                     //  SizedBox(height:5),

                        RaisedButton(
                          padding: EdgeInsets.fromLTRB(70,10,70,10),
                          onPressed: login,
                          child: Text('LOGIN',style: TextStyle(

                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold

                          )),

                          color: Colors.blueAccent,
                          shape: RoundedRectangleBorder(

                            borderRadius: BorderRadius.circular(20.0),
                          ),

                        )
                      ],
                    ),

                  ),
                ),

                GestureDetector(
                  child: Text('Create an Account?'),
                  onTap: navigateToSignUp,
                )
              ],
            ),
          ),
        )

    );
  }
}



