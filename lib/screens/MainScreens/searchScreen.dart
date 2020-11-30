import 'package:alumni/modals.dart/universalVariables.dart';
import 'package:alumni/resources/firebaseRepos.dart';
import 'package:alumni/screens/secondUserScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<QueryDocumentSnapshot> _list = [];
  List<QueryDocumentSnapshot> _smallList = [];
  TextEditingController _controller = new TextEditingController();
  FirebaseRepos _repository = new FirebaseRepos();
  customAppBar() {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: UniversalVariables.separatorColor,
      title: Container(
        height: 46,
        margin: EdgeInsets.symmetric(vertical: 10),
        child: TextFormField(
          controller: _controller,
          onChanged: (value) {
            print(value);
            setState(
              () {
                _smallList = [];
                _smallList = _list
                    .where((element) =>
                        (element.data()['name'].toString().toUpperCase())
                            .contains(_controller.text.toUpperCase()) ||
                        (element.data()['rollNumber'].toString().toUpperCase())
                            .contains(_controller.text.toUpperCase()))
                    .toList();
                if (_controller.text.length == 0) _smallList = [];
              },
            );
          },
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: "Search Users",
            hintStyle: TextStyle(color: Colors.grey[850], fontSize: 16),
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              setState(() {
                _controller.clear();
                _smallList = [];
              });
             
            })
      ],
    );
  }

  initState() {
    _repository.searchUserList().then((List<QueryDocumentSnapshot> list) {
      setState(() {
        _list = list;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      backgroundColor: UniversalVariables.separatorColor,
      body: Container(
        child: ListView.builder(
          itemCount: _smallList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SecondUserProfilePage(_smallList[index]),
                  ),
                );
              },
              child: ListTile(
                trailing: Icon(Icons.chat,color: Colors.white),
                title: Text(
                  _smallList[index].data()['name'].toString().toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                subtitle: Text(
                  _smallList[index]
                      .data()['rollNumber']
                      .toString()
                      .toUpperCase(),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
