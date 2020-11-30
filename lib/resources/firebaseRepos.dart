import 'dart:io';
import 'package:alumni/modals.dart/message.dart';
import 'package:alumni/modals.dart/posts.dart';
import 'package:alumni/modals.dart/users.dart';
import 'package:alumni/resources/firebaseMethods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRepos
{
  FirebaseMethods _methods= FirebaseMethods();

  User getCurrentUser()=>_methods.getCurrentUser();

  Future<bool> authenticateUser( String email)=> _methods.authenticateUser(email);

  Future<UserCredential> signUpWithEmail(String email,String password)=>_methods.signUpWithEmail(email, password);

  Future<void> addUserDataToDB(MyUser myUser,User user)=>_methods.addUserDataToDB(myUser, user);

  Future<UserCredential> signInWithEmail(String email,String password)=>_methods.signInWithEmail(email, password);

  Future<String> addImageToDB(File file) =>_methods.addImageToDB(file);

  Future<void> addPostDataToDB(Post post,String uidd) =>_methods.addPostDataToDB(post,uidd);

  Future<List<QueryDocumentSnapshot>> getPosts() =>_methods.getPosts();

  Future<List<QueryDocumentSnapshot>> getUserList()=>_methods.getUserList();

   Future<DocumentSnapshot> getCurrentUserData()=>_methods.getCurrentUserData();

   Future<void> updateLikes(postId, userId)=>_methods.updateLikes(postId, userId);

   Future<List<QueryDocumentSnapshot>> searchUserList()=>_methods.searchUserList();

   Future<List<QueryDocumentSnapshot>> getUserPosts(String uid)=>_methods.getUserPosts(uid);

   Future<void> deletePost(String id)=> _methods.deletePost(id);

   Future<void> addMessage(String sender, String receiver, Message message)=>_methods.addMessage(sender, receiver, message);

   Future<void> updateUserInfo(String name, String course, String branch,
      String rollNumber, String tag, String start, String end) =>_methods.updateUserInfo(name, course, branch, rollNumber, tag, start, end);

  Future<void>signOut()=>_methods.signOut();
  Future<bool> verifyEmail(String otp)=>_methods.verifyEmail(otp);
  Future<bool>sendMail()=>_methods.sendMail();
}