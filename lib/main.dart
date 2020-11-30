import 'package:alumni/resources/firebaseRepos.dart';
import 'package:alumni/screens/homeScreen.dart';
import 'package:alumni/screens/loginRelatedScreens/loginScreen.dart';
import 'package:alumni/screens/loginRelatedScreens/signUpScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseRepos _repositories = new FirebaseRepos();
  List<QueryDocumentSnapshot> _list = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     
      debugShowCheckedModeBanner: false,
      // home: OtpScreen(_list),

        home:  _repositories.getCurrentUser() != null &&_repositories.getCurrentUser().emailVerified? HomeScreen(_list):SignUp() ,
      routes: {
        'signUp': (context) => SignUp(),
        'signIn': (context) => LogIn(),
      },
    );
  }
}
