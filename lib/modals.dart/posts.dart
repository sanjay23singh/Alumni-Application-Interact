class Post {
  String uid;
  String id;
  String tag;
  String imageUrl;
  String text;
  List<String> likes;
  DateTime date;
  String name;
  String course;
  String branch;

  Post(
      {this.uid,
      this.id,
      this.tag,
      this.imageUrl,
      this.likes,
      this.date,
      this.branch,
      this.course,
      this.name,
      this.text});

  Map toMap(Post post) {
    var data = Map<String, dynamic>();
    data['uid'] = post.uid;
    data['id'] = post.id;
    data['likes'] = post.likes;
    data['tag'] = post.tag;
    data['text'] = post.text;
    data['imageUrl'] = post.imageUrl;
    data['date'] = post.date;
    data['name'] = post.name;
    data["course"] = post.course;
    data["branch"] = post.branch;
    return data;
  }

  Post.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.uid = mapData['id'];
    this.likes = mapData["likes"];
    this.tag = mapData["tag"];
    this.imageUrl = mapData["imageUrl"];
    this.text = mapData["text"];
    this.date=mapData['date'];
      this.name = mapData['name'];
    this.course=mapData["course"];
    this.branch=mapData["branch"];
  }
}
