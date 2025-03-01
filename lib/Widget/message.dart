class Message {
  Message({
    required this.toId,
    required this.msg,
    required this.read,
    required this.type,
    required this.send,
    required this.fromId,
  });
  late final String toId;
  late final String msg;
  late final String read;
  late final String send;
  late final String fromId;
  late final Type type;

  Message.fromJson(Map<String, dynamic> json){
    toId = json['toId'].toString();
    msg = json['msg'].toString();
    read = json['read'].toString();
    type = json['type'].toString()==Type.image.name ? Type.image: Type.text;
    send = json['send'].toString();
    fromId = json['fromId'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['toId'] = toId;
    data['msg'] = msg;
    data['read'] = read;
    data['type'] = type.name;
    data['send'] = send;
    data['fromId'] = fromId;
    return data;
  }

}
enum Type{text,image}