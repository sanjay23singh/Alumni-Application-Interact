import 'package:alumni/modals.dart/universalVariables.dart';
import 'package:alumni/resources/firebaseRepos.dart';
import 'package:alumni/screens/auxScreens/postCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PostScreen extends StatefulWidget {
  final List<QueryDocumentSnapshot> list;

  PostScreen(this.list);

  @override
  _PostScreenState createState() => _PostScreenState(list);
}

class _PostScreenState extends State<PostScreen> {
  List<QueryDocumentSnapshot> _list;
  _PostScreenState(this._list);
  FirebaseRepos _repositories = FirebaseRepos();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    _list = [];
    await fillList();
    _refreshController.refreshCompleted();
  }

  fillList() async {
    _repositories.getPosts().then((List<QueryDocumentSnapshot> list) {
      setState(() {
        _list = list;
      });
    });
  }

  void _onLoading() async {
    await fillList();
    _refreshController.loadComplete();
  }

  initState() {
     _repositories.getPosts().then((List<QueryDocumentSnapshot> list) {
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
        title: Text("Interact"),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff272c35),
      );
    }

    return Scaffold(
      appBar: _appbar(),
      backgroundColor: UniversalVariables.separatorColor,
      body: _list.length==0?Container(child: Center(child: CircularProgressIndicator())):SmartRefresher(
        header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.separated(
          itemBuilder: (c, i) => PostCard(_list[i]),
          itemCount: _list.length,
          separatorBuilder: (context, index) => Divider(
        color: Colors.grey,
      ),
        ),
      ),
    );
  }
}
