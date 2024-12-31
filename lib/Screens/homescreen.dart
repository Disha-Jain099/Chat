import 'package:chat/Screens/profilescreen.dart';
import 'package:chat/Services/authentication.dart';
import 'package:chat/Widget/chatuser.dart';
import 'package:chat/Widget/chatusercard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<ChatUser> list =[];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;
  @override
  void initState(){
    super.initState();
    AuthServices.getSelfInfo();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: WillPopScope(
        //if search is on & back button is pressed then close search
        //or simple close current screen on back button click
        onWillPop: (){
           if(_isSearching){
             setState(() {
               _isSearching = !_isSearching;
             });
             return Future.value(false);
           }else{
             return Future.value(true);
           }
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 2,
            leading: const Icon(Icons.home),
            title: _isSearching ? TextField(
              decoration: InputDecoration(
                border: InputBorder.none,hintText: 'Name, Email,...'
              ),
              autofocus: true,
              style: TextStyle(fontSize: 17,letterSpacing: 0.5),
              onChanged: (val){
                //search logic
                _searchList.clear();
                for(var i in list){
                  if(i.name.toLowerCase().contains(val.toLowerCase()) || i.email.toLowerCase().contains(val.toLowerCase())){
                    _searchList.add(i);
                  }
                  setState(() {
                    _searchList;
                  });
                }
              },
            ) : Text("We Chat"),
            actions: [
              IconButton(onPressed: (){
                setState(() {
                  _isSearching = !_isSearching;
                });
              }, icon: Icon(_isSearching ? CupertinoIcons.clear_circled_solid : Icons.search)),
              IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (_) => Profilescreen(user: AuthServices.me) ));
              }, icon: Icon(Icons.more_vert)),
            ],
          ),
          floatingActionButton:Padding(padding: EdgeInsets.only(bottom: 10),
          child: FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: (){},child: Icon(Icons.add_comment_rounded,color: Colors.white,),),

          ),
          body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: AuthServices.getAllUsers(),
            builder: (context,snapshot){
              switch(snapshot.connectionState){
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator(),);

                case ConnectionState.active:
                case ConnectionState.done:


                  final data = snapshot.data?.docs;
                  list = data?.map((e)=> ChatUser.fromJson(e.data())).toList() ?? [];

                if(list.isNotEmpty){
                  return  ListView.builder(
                      itemCount: _isSearching ? _searchList.length: list.length,
                      itemBuilder: (context,index){
                        return Chatusercard(user: _isSearching? _searchList[index]: list[index]);
                        //return Text('Name: ${list[index]}');
                      });
                }else{
                  return Center(child: Text('No Connection Found !'));
                }
              }

            },
          ),
        ),
      ),
    );
  }
}
