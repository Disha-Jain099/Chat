class ChatUser{
  ChatUser({
    required this.id,
    required this.lastActive,
    required this.image,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.password,
    required this.pushToken,
    required this.isOnline,
    required this.about,
  });
   late String id;
  late String lastActive;
  late String image;
  late String name;
  late String email;
  late String createdAt;
  late  String password;
  late String pushToken;
  late  bool isOnline;
  late  String about;

  ChatUser.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? '';
    lastActive = json['last_active'] ?? '';
    image = json['image'] ?? '';
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    createdAt = json['created_at'] ?? '';
    password = json['password'] ?? '';
    pushToken = json['push_token'] ?? '';
    isOnline = json['is_online'] ?? false;
    about = json['about'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['last_active'] = lastActive;
    data['image'] = image;
    data['name'] = name;
    data['email'] = email;
    data['created_at'] = createdAt;
    data['password'] = password;
    data['push_token'] = pushToken;
    data['is_online'] = isOnline;
    data['about'] = about;
    return data;
  }
}