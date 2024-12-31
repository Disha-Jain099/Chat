import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/Services/authentication.dart';
import 'package:chat/Widget/chatuser.dart';
import 'package:chat/Widget/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Viewprofile extends StatefulWidget {
  final ChatUser user;

  const Viewprofile({super.key, required this.user});


  @override
  State<Viewprofile> createState() => _ViewprofileState();
}


class _ViewprofileState extends State<Viewprofile> {



  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    return  GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 2,
          title:  Text(widget.user.name),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(width: mq.width,height: mq.height * .03,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height *.1),
                  child: CachedNetworkImage(
                      width: mq.height * .2,
                      height: mq.height * .2,
                      fit: BoxFit.cover,
                      imageUrl: widget.user.image,
                     errorWidget: (context,url,error)=> const CircleAvatar(
                       child: Icon(CupertinoIcons.person,size: 70,),
                     ),
                  ),
                ),
                SizedBox(height: mq.height * .03,),
                Text(widget.user.email,style: const TextStyle(color: Colors.black87,fontSize: 16),),
                SizedBox(height: mq.height * .02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('About: ',style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w500,fontSize: 16),),
                    Text(widget.user.about,style: const TextStyle(color: Colors.black87,fontSize: 16),),
                  ],
                )


              ],
            ),
          ),
        ),
      ),
    );
  }

  //for picking user profile picture

}


