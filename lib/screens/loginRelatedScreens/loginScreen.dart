import 'package:alumni/resources/firebaseRepos.dart';
import 'package:alumni/screens/auxScreens/otp_screen.dart';
import 'package:alumni/screens/homeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:email_validator/email_validator.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  FirebaseRepos _repository = new FirebaseRepos();
  bool shouldIRotate = false;
  User user;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Stack(children: [
              Container(
                height: height,
                width: width,
                color: Colors.black,
                child: Column(
                  children: [
                    Container(
                      height: height * .3,
                      alignment: Alignment.bottomCenter,
                      child: Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: Colors.lightBlue,
                        child: Text(
                          'Interact',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 60.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 100),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  hintStyle: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.all(10),
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0),
                                    borderSide:
                                        new BorderSide(color: Colors.blue),
                                  ),
                                ),
                                controller: _email,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                validator: (value) {
                                  if (!EmailValidator.validate(_email.text)) {
                                    return 'Please enter a vaild email';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.all(10),
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                obscureText: true,
                                controller: _password,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                validator: (value) {
                                  if (_password.text.length < 6) {
                                    return 'Enter a valid Password';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              RaisedButton(
                                color: Colors.lightBlue,
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(fontSize: 18),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    _repository
                                        .authenticateUser(_email.text)
                                        .then((bool correct) {
                                      if (!correct) {
                                        setState(() {
                                          shouldIRotate = true;
                                        });
                                        _repository
                                            .signInWithEmail(
                                                _email.text, _password.text)
                                            .then(
                                          (UserCredential userCred) {
                                            if (userCred != null) {
                                              _repository.getPosts().then(
                                                  (List<QueryDocumentSnapshot>
                                                      list) {
                                                if (_repository
                                                    .getCurrentUser()
                                                    .emailVerified) {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomeScreen(list),
                                                    ),
                                                  );
                                                } else {
                                                  print("sending mail");
                                                  _repository
                                                      .sendMail()
                                                      .then((value) {
                                                    if (value) {
                                                      print("sent mail");
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              OtpScreen(list),
                                                        ),
                                                      );
                                                    } else {
                                                      print(
                                                          "There was some error");
                                                      Scaffold.of(context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                            content: Text(
                                                              "Invalid Email or check your internet connection",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 16),
                                                            ),
                                                            backgroundColor:
                                                                Colors.white),
                                                      );
                                                    }
                                                  });
                                                }
                                                setState(() {
                                                  shouldIRotate = false;
                                                  _email.clear();
                                                  _password.clear();
                                                });
                                              });
                                            } else {
                                              Scaffold.of(context).showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                      "Wrong password",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16),
                                                    ),
                                                    backgroundColor:
                                                        Colors.white),
                                              );
                                            }
                                          },
                                        );
                                      } else {
                                        Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                "Account doesn't exists..please signUp",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                              backgroundColor: Colors.white),
                                        );
                                      }
                                    });
                                  }
                                },
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(color: Colors.white)),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account ?",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushReplacementNamed('signUp');
                                    },
                                    child: Text(
                                      " signUp now",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (shouldIRotate)
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ]),
          );
        },
      ),
    );
  }
}
