import 'package:alumni/modals.dart/universalVariables.dart';
import 'package:alumni/resources/firebaseRepos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditInfo extends StatefulWidget {
  @override
  _EditInfoState createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _name;
  TextEditingController _rollNumber;
  TextEditingController _course;
  TextEditingController _startingYear;
  TextEditingController _endingYear;
  TextEditingController _tag;
  TextEditingController _branch;
  FirebaseRepos _repository = FirebaseRepos();
  bool _shouldIRotate;
  DocumentSnapshot currentUserData;

  int currentYear;
  @override
  void initState() {
    currentYear = DateTime.now().year;
    _shouldIRotate = false;
    _repository.getCurrentUserData().then((value) {
      setState(() {
        currentUserData = value;
        _name = TextEditingController(text: currentUserData.data()['name']);
        _rollNumber =
            TextEditingController(text: currentUserData.data()['rollNumber']);
        _course = TextEditingController(text: currentUserData.data()['course']);
        _startingYear =
            TextEditingController(text: currentUserData.data()['startingYear']);
        _endingYear =
            TextEditingController(text: currentUserData.data()['endingYear']);
        _tag = TextEditingController(text: currentUserData.data()['tag']);
        _branch = TextEditingController(text: currentUserData.data()['branch']);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.separatorColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: UniversalVariables.separatorColor,
        centerTitle: true,
        title: Text(
          "Update info",
          style: TextStyle(color: Colors.white, fontSize: 23),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            if (currentUserData != null)
              Container(
                padding: EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        readOnly: true,
                        controller: _name,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        validator: (value) {
                          if (_name.text.length < 3)
                            return "Name must be atleast 3 characters long";
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Name",
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[900],
                          ),
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
                        readOnly: true,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
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
                        readOnly: true,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
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
                          if (_endingYear.text.length < 3 ||
                              _tag.text == 'ALUMNI' &&
                                  int.parse(_endingYear.text) > currentYear ||
                              _tag.text == 'STUDENT' &&
                                  int.parse(_endingYear.text) < currentYear)
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
                          "Save",
                          style: TextStyle(fontSize: 18),
                        ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              _shouldIRotate = true;
                            });

                            _repository
                                .updateUserInfo(
                                    _name.text,
                                    _course.text,
                                    _branch.text,
                                    _rollNumber.text,
                                    _tag.text,
                                    _startingYear.text,
                                    _endingYear.text)
                                .then((value) {
                              setState(() {
                                _shouldIRotate = false;
                              });
                            });
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
