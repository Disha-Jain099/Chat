import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/Screens/viewprofile.dart';
import 'package:chat/Widget/chatuser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Dialogs extends StatelessWidget {
  const Dialogs({super.key, required this.user});
  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    var mq=MediaQuery.of(context).size;
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
        ),
      content: SizedBox(width: mq.width*.6,height: mq.height*.35,
      child: Stack(
        children: [
          Positioned(
              left: mq.width*.04,
              top: mq.height*.02,
              width: mq.width *.44,
              child: Text(user.name,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),)),
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height*.25),
                child: CachedNetworkImage(
                    width: mq.height * .2,
                    height: mq.height * .2,
                    fit: BoxFit.cover,
                    imageUrl: user.image,
                    errorWidget: (context,url,error)=> CircleAvatar(child: Icon(CupertinoIcons.person,size: 90,),),
                ),
              ),
            ),
          Positioned(
          right: 0,
              top: 4,
              child: MaterialButton(onPressed: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_)=> Viewprofile(user: user)));
              },child: Icon(Icons.info_outline_rounded,color: Colors.blue,size: 30,),))
        ],
      ),
      ),
    );
  }
}

    