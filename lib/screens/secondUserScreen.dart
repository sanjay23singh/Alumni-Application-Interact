import 'package:alumni/modals.dart/universalVariables.dart';
import 'package:alumni/resources/firebaseRepos.dart';
import 'package:alumni/screens/auxScreens/mainChatScreen.dart';
import 'package:alumni/screens/auxScreens/postCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SecondUserProfilePage extends StatefulWidget {
  final DocumentSnapshot qds;
  SecondUserProfilePage(this.qds);
  @override
  _SecondUserProfilePageState createState() => _SecondUserProfilePageState();
}

class _SecondUserProfilePageState extends State<SecondUserProfilePage> {
  List<QueryDocumentSnapshot> _list = [];
  FirebaseRepos _repositories = new FirebaseRepos();

  initState() {
    _repositories
        .getUserPosts(widget.qds.data()['uid'])
        .then((List<QueryDocumentSnapshot> list) {
      setState(() {
        _list = list;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _appbar() {
      return AppBar(
        title: Text(widget.qds.data()['rollNumber']),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(0xff272c35),
        actions: [
          IconButton(
            icon: Icon(Icons.chat, color: Colors.white),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(widget.qds),
                  ),
                );
              
            },
          ),
        ],
      );
    }

    _firstContainer() {
      return Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 50),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Shimmer.fromColors(
                baseColor: widget.qds.data()['tag'].toString().toUpperCase() ==
                        "STUDENT"
                    ? Colors.lightBlue
                    : Colors.red,
                highlightColor: Colors.white,
                child: Text(
                  "${widget.qds.data()['tag'].toString().toUpperCase()} ${widget.qds.data()['course'].toString().toUpperCase()}",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                "${widget.qds.data()['startingYear'].toString().toUpperCase()} - ${widget.qds.data()['endingYear'].toString().toUpperCase()}",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                widget.qds.data()['name'].toString().toUpperCase(),
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                widget.qds.data()['branch'].toString(),
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      );
    }

    _secondContainer() {
      return Expanded(
        child: Container(
          child: _list.length == 0
              ? Container(
                  child: Center(
                    child: Text(
                      "No posts Yet....",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                )
              : _widgetContainer(),
        ),
      );
    }

    return Scaffold(
      appBar: _appbar(),
      backgroundColor: UniversalVariables.separatorColor,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            _firstContainer(),
            _secondContainer(),
          ],
        ),
      ),
    );
  }

  _widgetContainer() {
    return Container(
      child: ListView.separated(
        itemBuilder: (context, index) => PostCard(_list[index]),
        itemCount: _list.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey,
        ),
      ),
    );
  }
}
