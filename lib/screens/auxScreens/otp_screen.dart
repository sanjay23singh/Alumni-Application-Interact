import 'package:alumni/resources/firebaseRepos.dart';
import 'package:alumni/screens/homeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  final List<QueryDocumentSnapshot> list;
  OtpScreen(this.list);
  createState() => OtpScreenState();
}

class OtpScreenState extends State<OtpScreen> {
  FirebaseRepos _repository = new FirebaseRepos();
  String otp = "";

  build(context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .1,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  "We have sent you an email, Authenticate by clicking the link and then continue...",
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              Container(
                  height: MediaQuery.of(context).size.height * .6,
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Image.asset(
                    'assets/images/ff.gif',
                    fit: BoxFit.contain,
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height * .1,
              ),
              RaisedButton(
               
                onPressed: () {
                   setState((){
                     _repository.getCurrentUser().reload();
                   });
                  if (_repository.getCurrentUser().emailVerified) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(widget.list),
                      ),
                    );
                  } else {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                            "There is some error, try chekcing your internet connection",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          backgroundColor: Colors.white),
                    );
                  }
                },
                child: Text("Continue"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
