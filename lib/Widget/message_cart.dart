
import 'package:chat/Services/authentication.dart';
import 'package:chat/Widget/my_date_util.dart';
import 'package:flutter/material.dart';

import 'message.dart';
class MessageCart extends StatefulWidget {
  final Message message;
  const MessageCart({super.key, required this.message});

  @override
  State<MessageCart> createState() => _MessageCartState();
}

class _MessageCartState extends State<MessageCart> {
  @override
  Widget build(BuildContext context) {
    
    return AuthServices.user.uid == widget.message.fromId ? _blueMessage() : _greyMessage();
  }
  //sender message
  Widget _blueMessage(){
    var mq = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(width: mq.width * 0.04,),
            if(widget.message.read.isNotEmpty)
              const Icon(Icons.done_all_rounded,color: Colors.blue,size: 20,),
            SizedBox(width: 2,),
            //send time
            Text(MyDateUtil.getFormattedTime(context: context, time: widget.message.send),style: TextStyle(fontSize: 13,color: Colors.black54),)
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * 0.04,vertical: mq.height * .01
            ),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 221, 245,255),
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft  : Radius.circular(30)

                )
            ),
            child: Text(widget.message.msg,style: TextStyle(fontSize: 15,color: Colors.black87)),
          ),
        ),


      ],
    );
  }
  //receiver message
  Widget _greyMessage(){
    var mq = MediaQuery.of(context).size;
    //update last read message if sender and receiver are different
    if(widget.message.read.isNotEmpty){
      AuthServices.updateMessageReadStatus(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
              horizontal: mq.width * 0.04,vertical: mq.height * .01
            ),
            decoration: BoxDecoration(
              color: Colors.black12,
              border: Border.all(color: Colors.black87),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30)
          
              )
            ),
            child: Text(widget.message.msg,style: TextStyle(fontSize: 15,color: Colors.black87)),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: mq.width * 0.04),
          child: Text(MyDateUtil.getFormattedTime(context: context, time: widget.message.send),style: TextStyle(fontSize: 13,color: Colors.black54),),
        ),

      ],
    );
  }
}
