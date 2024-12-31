import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/Services/authentication.dart';
import 'package:chat/Widget/chatuser.dart';
import 'package:chat/Widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class Profilescreen extends StatefulWidget {
  final ChatUser user;

  const Profilescreen({super.key, required this.user});


  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}
class _ProfilescreenState extends State<Profilescreen> {

  Future<void> _confirmLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title:const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Logout')),
        ],
      ),
    );
    if (confirm ?? false) {
      await AuthServices().signOut(context);
    }
  }
  final _formKey = GlobalKey<FormState>();
  String ? _image;

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    return  GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 2,
          title: const Text('Profile Screen'),
        ),
        floatingActionButton: Padding(padding: EdgeInsets.only(bottom: 10),
        child: FloatingActionButton.extended(
            backgroundColor: Colors.blue,
            onPressed: _confirmLogout, icon: const Icon(Icons.logout,color: Colors.white,),label: const Text("Logout",style: TextStyle(color: Colors.white),)),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(width: mq.width,height: mq.height * .03,),
                  Stack(
                    children: [
                      _image != null  ?
                          //local image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height* .1),
                        child: Image.file(
                          File(_image!),
                          fit: BoxFit.cover,
                          width: mq.height * .2,
                          height: mq.height * .2,
                        )
                      ):

                      //image from server
                      ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height* .1),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        width: mq.height * .2,
                        height: mq.height * .2,
                        imageUrl: widget.user.image.isNotEmpty? widget.user.image: "",errorWidget: (context,url,error)=> const CircleAvatar(child: Icon(Icons.person,size: 60,),),),
                      ),
                      //edit image button
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          elevation: 1,
                          shape: CircleBorder(),
                          onPressed: (){
                            _showBottomSheet();
                          },color: Colors.white,child: Icon(Icons.edit,color: Colors.blue,),),
                      )
                    ],
                  ),
                  SizedBox(height: mq.height * .03,),
                  Text(widget.user.email,style: const TextStyle(color: Colors.black54,fontSize: 16),),
                  SizedBox(height: mq.height * .05),
                  TextFormField(
                    initialValue: widget.user.name,

                    onSaved: (val) => AuthServices.me.name = val ?? '' ,
                    validator:(val) => val!=null &&  val.isNotEmpty ? null : 'Required Field',

                    decoration: InputDecoration(
                      prefixIcon:const Icon(Icons.person,color: Colors.blue,),
                      border: OutlineInputBorder(
                    
                        borderRadius: BorderRadius.circular(12),
                    
                      ),
                      hintText: "Enter name",
                      label: const Text('Name')
                    ),
                    
                  ),
                  SizedBox(height: mq.height * .05),
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) => AuthServices.me.about = val ?? '' ,
                    validator:(val) => val!=null &&  val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.info_outline,color: Colors.blue,),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                    
                        ),
                        hintText: "Enter about",
                        label: const Text('About')
                    ),
                    
                  ),
                  SizedBox(height: mq.height * .05),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size(mq.width * 0.3,mq.height * .06)
                    
                    ),
                    onPressed: (){
                      if(_formKey.currentState!.validate()){
                        _formKey.currentState!.save();
                        AuthServices.updateUser().then((value){
                         showSnackBar(context,"Profile Update Successfully");
                        });
                      }
                    }, label: const Text("Update",style: TextStyle(color: Colors.white),),icon: const Icon(Icons.edit,color: Colors.white,),)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //for picking user profile picture
  void _showBottomSheet(){
    var mq = MediaQuery.of(context).size;
    showModalBottomSheet(context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
        ),
        builder: (_){
      return ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(top: mq.height *.03,bottom: mq.height * 0.05),
        children: [
          const Text("Pick Profile Picture", textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
          SizedBox(height: mq.height * .02,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
             ElevatedButton(
                 style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.white,
                   shape: const CircleBorder(),
                   fixedSize: Size(mq.width * .3,mq.height * .15)
                 ),
                 onPressed: ()async{
                   final ImagePicker picker = ImagePicker();
                   //pick an image
                   final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                   if(image != null){
                    print('Image Path: ${image.path} --MimeType: ${image.mimeType}');
                    setState(() {
                      _image = image.path;
                    });
                    //for hiding bottom sheet
                    Navigator.pop(context);
                   }


                 }, child:Image.asset('images/gallary.png')
             ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    fixedSize: Size(mq.width * .3,mq.height * .15)
                ),
                onPressed: ()async{
                  final ImagePicker picker = ImagePicker();
                  //pick an image
                  final XFile? image = await picker.pickImage(source: ImageSource.camera);
                  if(image != null){
                    print('Image Path: ${image.path} ');
                    setState(() {
                      _image = image.path;
                    });
                    //for hiding bottom sheet
                    Navigator.pop(context);
                  }
                }, child:Image.asset('images/camera1.png')
            )
          ],)
        ],
      );
    });
  }
}

