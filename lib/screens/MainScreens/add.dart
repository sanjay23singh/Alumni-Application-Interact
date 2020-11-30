import 'dart:io';
import 'package:alumni/modals.dart/posts.dart';
import 'package:alumni/modals.dart/universalVariables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../resources/firebaseRepos.dart';
import 'package:uuid/uuid.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  File _image;
  ImagePicker _picker;
  TextEditingController _textController = new TextEditingController();
  FirebaseRepos _repository = FirebaseRepos();
  bool shouldIRotate;
  String imgUrl;
  var uid;

  initState() {
    _picker = ImagePicker();
    shouldIRotate = false;
    uid = Uuid();
    super.initState();
  }

  Future getImageFromCamera() async {
    final _pickedImage = await _picker.getImage(source: ImageSource.camera);
    setState(() {
      if (_pickedImage != null) _image = File(_pickedImage.path);
    });
  }

  Future getImageFromGallery() async {
    final _pickedImage = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (_pickedImage != null) _image = File(_pickedImage.path);
    });
  }

  Future _showDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Select image"),
            content: Text("Choose image from"),
            actions: [
              FlatButton(
                  onPressed: () {
                    getImageFromCamera()
                        .then((value) => Navigator.pop(context));
                  },
                  child: Text("Camera")),
              FlatButton(
                  onPressed: () {
                    getImageFromGallery()
                        .then((value) => Navigator.pop(context));
                  },
                  child: Text("Gallery")),
            ],
          );
        });
  }

  Future _showUploadingDialog() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Uploading post"),
          content: Container(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }

  _appbar() {
    return AppBar(
      title: Text("Create Post"),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 10.0),
          child: IconButton(
            icon: Icon(
              Icons.check,
              size: 25,
            ),
            onPressed: () {
              if (_image == null &&
                  (_textController.text.trim().length == 0 ||
                      _textController.text.length == 0)) {
              } else {
                setState(() {
                  _showUploadingDialog();
                });
                _repository.addImageToDB(_image).then(
                  (String _imageUrl) {
                    setState(() {
                      imgUrl = _imageUrl;
                    });
                    _repository
                        .getCurrentUserData()
                        .then((DocumentSnapshot userData) {
                      Map<String, dynamic> ud = userData.data();
                      User _currentUser = _repository.getCurrentUser();
                      String uidd = uid.v1().toString();

                      Post _myPost = new Post(
                        imageUrl: _imageUrl,
                        likes: [],
                        text: _textController.text,
                        uid: _currentUser.uid,
                        date: DateTime.now(),
                        branch: ud['branch'],
                        course: ud['course'],
                        name: ud['name'],
                        id: uidd,
                        tag: ud['tag'],
                      );

                      _repository.addPostDataToDB(_myPost, uidd).then((value) {
                        setState(() {
                          Navigator.of(context).pop();
                          _image = null;
                          _textController.clear();
                        });
                      });
                    });
                  },
                );
              }
            },
          ),
        )
      ],
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      backgroundColor: UniversalVariables.separatorColor,
    );
  }

  Widget imageContainer() {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(_image),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget textContainer() {
    return Container(
      padding: EdgeInsets.all(10),
      //
      child: TextField(
        controller: _textController,
        maxLines: 10,
        maxLength: 100,
        maxLengthEnforced: true,
        decoration: InputDecoration(
          hintText: "Write something about your post..",
          helperStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color(0xff2b9ed4))),
        ),
      ),
      //
    );
  }

  Widget buttonContainer() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 10),
      child: RaisedButton(
        onPressed: () {
          _showDialog();
        },
        child: Text("Add image",
            style: TextStyle(color: Colors.white, fontSize: 16)),
        color: Color(0xff2b9ed4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      backgroundColor: UniversalVariables.separatorColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                if (_image != null) imageContainer(),
                textContainer(),
                if (_image == null) buttonContainer(),
              ],
            ),
          ),
          // if (shouldIRotate == true)
          //   Container(
          //     height: MediaQuery.of(context).size.height,
          //     width: MediaQuery.of(context).size.width,
          //     child: Center(
          //       child: CircularProgressIndicator(),
          //     ),
          //   )
        ],
      ),
    );
  }
}
