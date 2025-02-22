import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/Screens/chat_screen.dart';
import 'package:chat/Services/authentication.dart';
import 'package:chat/Widget/dialogs.dart';
import 'package:chat/Widget/my_date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chatuser.dart';
import 'message.dart';
class Chatusercard extends StatefulWidget {
  final ChatUser user;
  const Chatusercard({super.key, required this.user});

  @override
  State<Chatusercard> createState() => _ChatusercardState();
}

class _ChatusercardState extends State<Chatusercard> {
  Message? message;
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Card(
      elevation: 0.1,
      child: InkWell(
        onTap: (){
          Navigator.push(context,MaterialPageRoute(builder: (_)=> ChatScreen(user: widget.user,)));
        },
        child: StreamBuilder(stream: AuthServices.getLastMessage(widget.user), builder: (context,snapshot){
          final data =snapshot.data?.docs;
          final list =data?.map((e)=> Message.fromJson(e.data())).toList() ?? [];
          if(list.isNotEmpty) message = list[0];
          return ListTile(

            // leading: CircleAvatar(child: Icon(Icons.person),),
            leading : InkWell(
              onTap: (){
                showDialog(context: context, builder:(_)=>Dialogs(user: widget.user,) );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  fit: BoxFit.fill,
              
                  width: 50,
                  height: 50,
                  imageUrl: widget.user.image,
                  //placeholder: (context,url)=> CircularProgressIndicator(),
                  errorWidget: (context,url,error)=> const CircleAvatar(child: Icon(CupertinoIcons.person),),
                ),
              ),
            ),
            title: Text(widget.user.name),
            subtitle: Text(message != null ?
            message!.msg :widget.user.about,maxLines: 1,),
            trailing: message == null
                ? null//show nothing when no message is sent
                : message!.read.isEmpty && message!.fromId != AuthServices.user.uid
                ?
                Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: Colors.greenAccent.shade400,
                borderRadius: BorderRadius.circular(10)
              ),
            ): Text(MyDateUtil.getLastMessageTime(context: context, time: message!.send),style: TextStyle(color: Colors.black54)),
          );


        })
      ),);
  }
}
