class Message {
  String senderId;
  String receiverId;

  String text;
  DateTime date;

  Message({this.senderId, this.receiverId, this.date, this.text});

  Map toMap(Message message) {
    var data = Map<String, dynamic>();
    data['senderId'] = message.senderId;
    data['id'] = message.receiverId;
    data['text'] = message.text;
    data['date'] = message.date;

    return data;
  }

  Message.fromMap(Map<String, dynamic> mapData) {
    this.senderId = mapData['senderId'];
    this.receiverId = mapData['receiverId'];
    this.text = mapData["text"];
    this.date = mapData['date'];
  }
}
