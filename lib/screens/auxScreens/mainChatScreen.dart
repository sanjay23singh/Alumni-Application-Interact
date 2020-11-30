import 'package:alumni/modals.dart/message.dart';
import 'package:alumni/modals.dart/universalVariables.dart';
import 'package:alumni/resources/firebaseRepos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final QueryDocumentSnapshot qds;
  ChatScreen(this.qds);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseRepos _repository = FirebaseRepos();
  TextEditingController _controller = new TextEditingController();

  User currentUser;

  initState() {
    currentUser = _repository.getCurrentUser();
    super.initState();
  }

  _customAppbar() {
    return AppBar(
      elevation: 0,
      backgroundColor: UniversalVariables.separatorColor,
      centerTitle: true,
      title: Text(
        widget.qds.data()['name'],
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  _bottomContainer() {
    return Container(
      margin: EdgeInsets.only(
        left: 10,
        right:10,
        bottom: 10
      ),
      height: 60,
      width: MediaQuery.of(context).size.width,
      color: UniversalVariables.separatorColor,
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: TextField(
                
                style: TextStyle( fontSize: 20),
                controller: _controller,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Colors.white,
            ),
            onPressed: () {
              if (_controller.text.length == 0 ||
                  _controller.text.trim() == "") {
              } else {
                String _text=_controller.text;
                setState(() {
                _controller.clear();
                });
                _repository
                    .addMessage(
                  widget.qds.data()['uid'],
                  _repository.getCurrentUser().uid,
                  Message(
                      date: DateTime.now(),
                      receiverId: widget.qds.data()['uid'],
                      senderId: currentUser.uid,
                      text: _text),
                );
                    
              }
            },
          ),
        ],
      ),
    );
  }

  _messageContainer() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .doc(currentUser.uid)
          .collection(widget.qds.data()['uid'])
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data == null)
          return Center(child: CircularProgressIndicator());
        else
          return ListView.builder(
            reverse: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) =>
                chatMessageItem(snapshot.data.docs[index]),
          );
      },
    );
  }

  chatMessageItem(data) {
    return Container(
      padding: EdgeInsets.all(8),
      alignment: data['senderId'] == currentUser.uid
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: data['senderId'] == currentUser.uid
          ? _senderLayout(data)
          : _receiverLayout(data),
    );
  }

  _senderLayout(data) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .60),
      decoration: BoxDecoration(
        color: UniversalVariables.senderColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          data['text'],
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  _receiverLayout(data) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .60),
      decoration: BoxDecoration(
        color: UniversalVariables.receiverColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          data['text'],
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.separatorColor,
      appBar: _customAppbar(),
      body: Column(
        children: [
          Expanded(
            child:Container(
              alignment: Alignment.topCenter,
            child: _messageContainer(),
            ),
          ),
          _bottomContainer(),
        ],
      ),
    );
  }
}
