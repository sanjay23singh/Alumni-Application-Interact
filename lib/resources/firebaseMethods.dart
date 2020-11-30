import 'dart:io';
import 'package:alumni/modals.dart/message.dart';
import 'package:alumni/modals.dart/posts.dart';
import 'package:alumni/modals.dart/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class FirebaseMethods {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://chatappdemo-f3950.appspot.com');

  StorageUploadTask _uploadTask;

  User getCurrentUser() {
    User currentUser = _auth.currentUser;
    return currentUser;
  }

  Future<bool> authenticateUser(String email) async {
    QuerySnapshot result = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    final List<DocumentSnapshot> list = result.docs;

    return list.length == 0 ? true : false;
  }

  Future<UserCredential> signUpWithEmail(String email, String password) async {
    UserCredential user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user;
  }

  Future<void> addUserDataToDB(MyUser myUser, User user) async {
    await firestore.collection('users').doc(user.uid).set(myUser.toMap(myUser));
  }

  Future<UserCredential> signInWithEmail(String email, String password) async {
    UserCredential user;
    try {
      user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on PlatformException catch (e) {
      if (e.code == 'invalid-email') {
        // Do something :D
      }
      return null;
    }
    return user;
  }

  Future<String> addImageToDB(File file) async {
    if (file == null) return null;
    String _filePath = 'images/${DateTime.now()}.png';
    String _imageUrl;

    _uploadTask = _storage.ref().child(_filePath).putFile(file);
    StorageTaskSnapshot taskSnapshot = await _uploadTask.onComplete;

    // Waits till the file is uploaded then stores the download url
    await taskSnapshot.ref.getDownloadURL().then((value) {
      _imageUrl = value;
    });
    return _imageUrl;
  }

  Future<void> addPostDataToDB(Post post, String uidd) async {
    await firestore.collection('posts').doc(uidd).set(post.toMap(post));
  }

  Future<List<QueryDocumentSnapshot>> getPosts() async {
    QuerySnapshot _result = await firestore
        .collection('posts')
        .orderBy('date', descending: true)
        .get();

    List<QueryDocumentSnapshot> list = [];
    for (int i = 0; i < _result.docs.length; i++) {
      list.add(_result.docs[i]);
    }

    return list;
  }

  Future<List<QueryDocumentSnapshot>> getUserList() async {
    QuerySnapshot _result = await firestore.collection('users').get();

    List<QueryDocumentSnapshot> list = [];
    for (int i = 0; i < _result.docs.length; i++) {
      if (_result.docs[i].data()['uid'] != getCurrentUser().uid) {
        list.add(_result.docs[i]);
      }
    }

    return list;
  }

  Future<DocumentSnapshot> getCurrentUserData() async {
    User _currentUser = getCurrentUser();
    DocumentSnapshot _result =
        await firestore.collection('users').doc(_currentUser.uid).get();

    return _result;
  }

  Future<bool> updateLikes(postId, userId) async {
    print(postId + " " + userId);
    QuerySnapshot value = await firestore
        .collection('posts')
        .where('id', isEqualTo: postId)
        .get();

    List<dynamic> list = value.docs[0]['likes'];
    List<String> myNewList = [];
    bool occured = false;
    bool cout;
    for (int i = 0; i < list.length; i++) {
      if (list[i] == userId) {
        occured = true;
        cout = false;
      } else
        myNewList.add(list[i]);
    }

    if (!occured) {
      myNewList.add(userId);
      cout = true;
    }
    await firestore.collection('posts').doc(postId).update({
      'likes': myNewList,
    });
    return cout;
  }

  Future<List<QueryDocumentSnapshot>> searchUserList() async {
    List<QueryDocumentSnapshot> list = [];
    User _currentUser = getCurrentUser();
    QuerySnapshot _result = await firestore.collection('users').get();

    for (int i = 0; i < _result.docs.length; i++) {
      if (_result.docs[i]['uid'] != _currentUser.uid) list.add(_result.docs[i]);
    }

    return list;
  }

  Future<List<QueryDocumentSnapshot>> getUserPosts(String uid) async {
    QuerySnapshot _result = await firestore
        .collection('posts')
        .where(
          'uid',
          isEqualTo: uid,
        )
        // .orderBy('date', descending: true)
        .get();

    List<QueryDocumentSnapshot> list = [];
    for (int i = 0; i < _result.docs.length; i++) {
      list.add(_result.docs[i]);
    }
    list.sort((a, b) => (b.data()['date']).compareTo(a.data()['date']));
    return list;
  }

  Future<void> deletePost(String id) async {
    return await firestore.collection('posts').doc(id).delete();
  }

  Future<void> addMessage(
      String sender, String receiver, Message message) async {
    await firestore
        .collection('messages')
        .doc(sender)
        .collection(receiver)
        .doc()
        .set(
          message.toMap(message),
        );
    return await firestore
        .collection('messages')
        .doc(receiver)
        .collection(sender)
        .doc()
        .set(
          message.toMap(message),
        );
  }

  Future<void> updateUserInfo(String name, String course, String branch,
      String rollNumber, String tag, String start, String end) async {
    return firestore.collection('users').doc(getCurrentUser().uid).update({
      'name': name,
      'tag': tag,
      'course': course,
      'branch': branch,
      'rollNumber': rollNumber,
      'startingYear': start,
      'endingYear': end,
    });
  }

  Future<void> signOut() async {
    return await _auth.signOut();
  }

  Future<bool> verifyEmail(String otp) async {
    try {
      await _auth.checkActionCode(otp);
      await _auth.applyActionCode(otp);

      // If successful, reload the user:
      _auth.currentUser.reload();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-action-code') {
        print('The code is invalid.');
      }
      return false;
    }
  }

  Future<bool> sendMail() async {
    try {
      print("sending mail from firevaseee");
      await FirebaseAuth.instance.currentUser.sendEmailVerification();
      return true;
    } catch (e) {
      return false;
    }
  }
}
