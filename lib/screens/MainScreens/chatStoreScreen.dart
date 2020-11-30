// // import 'package:alumni/modals.dart/universalVariables.dart';
// // import 'package:alumni/resources/firebaseRepos.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:alumni/modals.dart/universalVariables.dart';
// import 'package:alumni/resources/firebaseRepos.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';

// // class ChatStore extends StatefulWidget {
// //   @override
// //   _ChatStoreState createState() => _ChatStoreState();
// // }

// // class _ChatStoreState extends State<ChatStore> {

// //   FirebaseRepos _repository=new FirebaseRepos();

// //   _messageUserInfoTile(qds)async{

// //   await FirebaseFirestore.instance.collection('users').doc(qds).get().then((value) {
// //     return ListTile();
// //   });
// //       // return ListTile(

// //       // );
// //   }
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: UniversalVariables.separatorColor,
// //       appBar: AppBar(
// //         automaticallyImplyLeading: false,
// //         backgroundColor: UniversalVariables.separatorColor,
// //         centerTitle: true,
// //         title: Text(
// //           "Messages",
// //           style: TextStyle(color: Colors.white, fontSize: 23),
// //         ),
// //         elevation: 0,
// //       ),

// //       body:  Container(
// //           child: StreamBuilder(
// //             stream: FirebaseFirestore.instance.collection('messages').doc(_repository.getCurrentUser().uid).snapshots(),
// //             builder: (context,snapshot){
// //               return ListView.builder(itemBuilder: (context, index){
// //                 return _messageUserInfoTile(snapshot.data[index]);
// //               },);
// //             }
// //           ),
// //         ),
// //     );
// //   }
// // }

// class ChatStore extends StatefulWidget {
//   createState() => ChatStoreState();
// }

// class ChatStoreState extends State<ChatStore> {
//   FirebaseRepos _repository = new FirebaseRepos();

//   customAppBar() {
//     return AppBar(
//       title: Text("Messages"),
//       elevation: 0,
//       centerTitle: true,
//       backgroundColor: UniversalVariables.separatorColor,
//     );
//   }

//   build(context) {
//     return Scaffold(
//       appBar: customAppBar(),
//       backgroundColor: UniversalVariables.separatorColor,
//       body: Container(
//         height: MediaQuery.of(context).size.height,
        
//       ),
//     );
//   }

//   messageItem(ds) {
//     return ListTile(
//       title: Text("Hi", style: TextStyle(color: Colors.white)),
//     );
//   }
// }
