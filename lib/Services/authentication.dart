import 'package:chat/Screens/loginscreen.dart';
import 'package:chat/Widget/chatuser.dart';
import 'package:chat/Widget/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthServices {
  //for storing the data in cloud firestore
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  //for authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;
static User get user => FirebaseAuth.instance.currentUser!;
// static   ChatUser me;
  static late ChatUser me;
static Future<bool> userExists()async{
  return (await FirebaseFirestore.instance.collection('users').doc(user.uid).get()).exists;
}
static Future<void> getSelfInfo() async{
  await FirebaseFirestore.instance.collection('users').doc(user.uid).get().then((user) async {
    if(user.exists){
      me = ChatUser.fromJson(user.data()!);
    }else{

    }
  });
}
//for signup
  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add user to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        //'password':password,
        'lastActive': DateTime.now().millisecondsSinceEpoch.toString(),
        'about': "Busy",
        'image': userCredential.user?.photoURL ?? '',
        'pushToken': "",
        'isOnline': false,
        'id': userCredential.user!.uid,
      });

      return "Success";
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.code} - ${e.message}");
      return e.message ?? "An error occurred";
    } catch (e) {
      print("Unknown error: $e");
      return "Something went wrong. Please try again.";
    }
    
  }
  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=> Loginscreen()), (route)=>false);

  }





  Future<String> loginUser({
  required String email,
  required String password,
})async{
    String res ="Some error occured";
    try{
     if(email.isNotEmpty || password.isNotEmpty){
       await _auth.signInWithEmailAndPassword(email: email, password: password);

       res= "success";

     }else{
       res= "Please enter all the fields";
     }
    }catch(e){
      return e.toString();

    }
    return res;
}
 static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(){
    return FirebaseFirestore.instance.collection('users').where('id',isNotEqualTo: user.uid).snapshots();
}
static Future<void> updateUser()async{
  await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
    'name': me.name,
    'about': me.about
  });
}
//for getting conversation id
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode? '${user.uid}_$id' : '${id}_${user.uid}';
//for accessing msg
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(ChatUser user){
    return FirebaseFirestore.instance.collection('chats/${getConversationID(user.id)}/messages/').snapshots();
  }
  //for sending message
static Future<void> sendMessage(ChatUser chatUser,String msg)async{
    //message sending time
  final time = DateTime.now().millisecondsSinceEpoch.toString();
  //message to send
  final Message message = Message(toId: chatUser.id, msg: msg, read: '', type: Type.text, send: time, fromId: user.uid);
  final ref = FirebaseFirestore.instance.collection('chats/${getConversationID(chatUser.id)}/messages/');
  await ref.doc(time).set(message.toJson());
}

//update read status of message
static Future<void> updateMessageReadStatus(Message message)async{
    FirebaseFirestore.instance.collection('chats/${getConversationID(message.fromId)}/messages/').doc(message.send).update({'read': DateTime.now().millisecondsSinceEpoch.toString()});

}

//get only last message
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(ChatUser user){
    return FirebaseFirestore.instance.collection('chats/${getConversationID(user.id)}/messages/').orderBy('send',descending: true)
        .limit(1)
        .snapshots();
  }

  //for getting specific user info
  static Stream<QuerySnapshot<Map<String,dynamic>>> getUserInfo(ChatUser chatUser){
    return FirebaseFirestore.instance.collection('users').where('id',isEqualTo: chatUser.id).snapshots();
  }
  //ipdate online or last active status
static Future<void> updateActiveStatus(bool isOnline) async{
    FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString()
    });
}
}
