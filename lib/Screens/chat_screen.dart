import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/Screens/viewprofile.dart';
import 'package:chat/Services/authentication.dart';
import 'package:chat/Widget/message.dart';
import 'package:chat/Widget/message_cart.dart';
import 'package:chat/Widget/my_date_util.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Widget/chatuser.dart';
class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> list =[];
  //for showing emoji
  bool _showEmoji = false;
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState(){
    super.initState();
    _focusNode.addListener((){
      if(_focusNode.hasFocus){
        setState(() {
          _showEmoji =false;
        });
      }
    });
  }




  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus,
      child: SafeArea(
        child: WillPopScope(
          onWillPop: (){
            if(_showEmoji){
              setState(() {
                _showEmoji=!_showEmoji;

              });
              return Future.value(false);
            }else{
              return Future.value(true);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: mq.height * 0.07,
              elevation: 1,
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
            ),
            body: Column(children: [
              Expanded(
                child: StreamBuilder(
               stream: AuthServices.getMessages(widget.user),
                  builder: (context,snapshot){
                    switch(snapshot.connectionState){
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                       // return const Center(child: CircularProgressIndicator(),);
          
                      case ConnectionState.active:
                      case ConnectionState.done:
          
          
                         final data = snapshot.data?.docs;
                         //list = data?.map((doc) => Message.fromJson(doc.data() as Map<String,dynamic>)).toList() ?? [];
          
                         list = data?.map((e)=> Message.fromJson(e.data())).toList() ?? [];
          
                        if(list.isNotEmpty){
                          return  ListView.builder(
                            physics: BouncingScrollPhysics(),
                              itemCount: list.length,
                              itemBuilder: (context,index){
                                return MessageCart(message: list[index]);
                                //return Text('Name: ${list[index]}');
                              });
                        }else{
                          return Center(child: Text('Say Hii!',style: TextStyle(fontSize: 20),));
                        }
                    }
          
                  },
                ),
              ),
              _chatInput(),
              if(_showEmoji)
                SizedBox(
                  height: mq.height *.40,
                  child: EmojiPicker(
                    textEditingController: _textController,
                    config: Config(
                      emojiViewConfig: EmojiViewConfig(
                        backgroundColor:Color.fromARGB(255, 234, 248, 255) ,
                        columns: 8,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                      )
                    ),
                  ),
                )
          
          
            ],),
          ),
        ),
      ),
    );
  }
  Widget _appBar(){
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_) => Viewprofile(user: widget.user)));
      },
      child: StreamBuilder(stream:AuthServices.getUserInfo(widget.user) , builder: (context,snapshot){
        final data = snapshot.data?.docs;
        final list = data?.map((e)=> ChatUser.fromJson(e.data())).toList()??[];
        return Row(
          children: [
            IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back,color: Colors.black54,)),
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                width: 45,
                height: 45,
                imageUrl: list.isNotEmpty ? list[0].image: widget.user.image,
                //placeholder: (context,url)=> CircularProgressIndicator(),
                errorWidget: (context,url,error)=> const CircleAvatar(child: Icon(CupertinoIcons.person),),
              ),
            ),
            const SizedBox(width: 10,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(list.isNotEmpty ? list[0].name : widget.user.name,style: TextStyle(fontSize: 16,color: Colors.black87,fontWeight: FontWeight.w500 ),),
                SizedBox(height: 2,),
                Text(list.isNotEmpty ?
                    list[0].isOnline? 'Online':
                  MyDateUtil.getLastActiveTime(context: context, lastActive: list[0].lastActive):
                MyDateUtil.getLastActiveTime(context: context, lastActive: widget.user.lastActive)
                  ,style: TextStyle(fontSize: 13,color: Colors.black54 ),)
              ],)
          ],
        );
      })
    );
  }
  //bottom chat input field
Widget _chatInput(){
    var mq = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: mq.height * 0.01,horizontal: mq.width * .025 ),
      child: Row(
        children:[ Expanded(
          child: Card(
            child: Row(
              children: [
                IconButton(onPressed: (){
                  FocusScope.of(context).unfocus();
                  setState(() {
                    _showEmoji = !_showEmoji;
                  });
                }, icon: Icon(Icons.emoji_emotions_outlined,color: Colors.blue,)),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    onTap: () {
                      if (_showEmoji) {
                        setState(() {
                          _showEmoji = !_showEmoji;
                        });
                      }
                    },
                    controller: _textController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText:'Type Something...',
                      hintStyle: TextStyle(color: Colors.blue),
                      border: InputBorder.none
                    ),
                  ),
                ),
                IconButton(onPressed: (){}, icon: Icon(Icons.image,color: Colors.blue,)),
                IconButton(onPressed: (){}, icon: Icon(Icons.camera_alt_rounded,color: Colors.blue,))
              ],
            ),
          ),
        ),
           MaterialButton(
            minWidth: 0,
            onPressed: (){
              if(_textController.text.isNotEmpty){
                AuthServices.sendMessage(widget.user, _textController.text);
                _textController.text = '';
              }
            },padding: EdgeInsets.only(top: 10,bottom: 10,right: 5,left: 10),
          shape: const CircleBorder(),
              color: Colors.blue,
            child: Icon(Icons.send,color: Colors.white,size: 26,),
          ),
        ]
      ),
    );
}
}
