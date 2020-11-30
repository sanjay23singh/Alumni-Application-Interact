import 'package:alumni/modals.dart/universalVariables.dart';
import 'package:alumni/modals.dart/users.dart';
import 'package:alumni/resources/firebaseRepos.dart';
import 'package:alumni/screens/auxScreens/otp_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SecondScreen extends StatefulWidget {
  final String email;
  final String password;

  SecondScreen(this.email, this.password);
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  TextEditingController _rollNumber = TextEditingController();
  TextEditingController _course = TextEditingController();
  TextEditingController _startingYear = TextEditingController();
  TextEditingController _endingYear = TextEditingController();
  TextEditingController _tag = TextEditingController();
  TextEditingController _branch = TextEditingController();
  FirebaseRepos _repository = FirebaseRepos();
  bool _shouldIRotate;

  int currentYear;
  @override
  void initState() {
    currentYear = DateTime.now().year;
    _shouldIRotate = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: UniversalVariables.blackColor,
        centerTitle: true,
        title: Text(
          "Enter info",
          style: TextStyle(color: Colors.white, fontSize: 23),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _name,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      validator: (value) {
                        if (_name.text.length < 3)
                          return "Name must be atleast 3 characters long";
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Name",
                        hintStyle:
                            TextStyle(fontSize: 16, color: Colors.grey[900]),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.lightBlue)),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _course,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      validator: (value) {
                        if (_course.text.length < 3)
                          return "Course name must be atleast 3 characters long";
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Course",
                        hintStyle:
                            TextStyle(fontSize: 16, color: Colors.grey[900]),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.lightBlue)),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _branch,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      validator: (value) {
                        if (_branch.text.length < 3)
                          return "branch name must be atleast 2 characters long";
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Branch",
                        hintStyle:
                            TextStyle(fontSize: 16, color: Colors.grey[900]),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.lightBlue)),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _rollNumber,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      validator: (value) {
                        if (_rollNumber.text.length < 8)
                          return "Roll number must be atleast 8 characters long";
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Roll number",
                        hintStyle:
                            TextStyle(fontSize: 16, color: Colors.grey[900]),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.lightBlue)),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _tag,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      validator: (value) {
                        if (_tag.text.toUpperCase() != "STUDENT" &&
                            _tag.text.toUpperCase() != "ALUMNI")
                          return "Must be either student or alumni";
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Student or Alumni",
                        hintStyle:
                            TextStyle(fontSize: 16, color: Colors.grey[900]),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.lightBlue)),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _startingYear,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      validator: (value) {
                        if (_startingYear.text.length < 4 ||
                            int.parse(_startingYear.text) > currentYear)
                          return "Enter a Valid year";
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Starting year",
                        hintStyle:
                            TextStyle(fontSize: 16, color: Colors.grey[900]),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.lightBlue)),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _endingYear,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      validator: (value) {
                        if (_endingYear.text.length < 3)
                          return "Enter a valid year";
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "End year",
                        hintStyle:
                            TextStyle(fontSize: 16, color: Colors.grey[900]),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.lightBlue)),
                      ),
                    ),
                    SizedBox(height: 20),
                    RaisedButton(
                      color: Colors.lightBlue,
                      child: Text(
                        "Continue",
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            _shouldIRotate = true;
                          });
                          _repository
                              .signUpWithEmail(widget.email, widget.password)
                              .then(
                            (userCredential) {
                              User currentUser = userCredential.user;

                              MyUser myUser = MyUser(
                                name: _name.text,
                                course: _course.text,
                                email: widget.email,
                                endingYear: _endingYear.text,
                                rollNumber: _rollNumber.text,
                                startingYear: _startingYear.text,
                                uid: currentUser.uid,
                                tag: _tag.text.toUpperCase(),
                                branch: _branch.text.toUpperCase(),
                                username: (_name.text).split(" ")[0],
                                chattingPartners: [],
                              );

                              _repository
                                  .addUserDataToDB(myUser, currentUser)
                                  .then(
                                (value) {
                                  _repository
                                      .getPosts()
                                      .then((List<QueryDocumentSnapshot> list) {
                                    setState(
                                      () {
                                        _shouldIRotate = false;
                                      },
                                    );
                                    
                                    // Navigator.pushReplacement(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => OtpScreen(value),
                                    //   ),
                                    // );
                                    _repository.sendMail().then((value) {
                                      if (value) {
                                        print("sent mail");
                                        Navigator.of(context).pop();
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OtpScreen(list),
                                          ),
                                        );
                                      } else {
                                        print("There was some error");
                                        Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                "Invalid Email or check your internet connection",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                              backgroundColor: Colors.white),
                                        );
                                      }
                                    });
                                  });
                                },
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            _shouldIRotate
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(child: CircularProgressIndicator()))
                : Container(),
          ],
        ),
      ),
    );
  }
}
