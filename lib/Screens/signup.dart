
import 'package:chat/Screens/homescreen.dart';
import 'package:chat/Screens/loginscreen.dart';
import 'package:chat/Screens/textfield.dart';
import 'package:chat/Services/authentication.dart';
import 'package:chat/Widget/snack_bar.dart';
import 'package:flutter/material.dart';

import '../Widget/button.dart';
class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  //for controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool isLoading = false;

  void signUpUser()async{
    String res = await AuthServices().signUpUser(email: emailController.text.trim(), password: passController.text.trim(), name: nameController.text.trim());
    if(res == "Success"){
      setState(() {
        isLoading = true;
      });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const Homescreen()));
    }else{
      setState(() {
       isLoading = false;
      });
      //show the error msg
      showSnackBar(context, res);
    }
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: height
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 70),
                      child: SizedBox(
                          width: double.infinity,
                          height: height/3.4,
                          child: Image.asset("images/signup.jpg")),
                    ),
                    const SizedBox(height: 15,),
                    Textfield(textEditingController: nameController, hintText: "Enter your name", icon: Icons.person),
                    Textfield(textEditingController: emailController, hintText: "Enter your email", icon: Icons.email),
                    Textfield(textEditingController: passController, hintText: "Enter your password",isPass: true, icon: Icons.lock),
            
                    Button(onTab: signUpUser, text: "Sign Up"),
                    SizedBox(height: height/15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?",style: TextStyle(fontSize: 16),),
                        GestureDetector(
                          onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (_)=> const Loginscreen()));
                          },
                          child: const Text(" Login",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                        )
                      ],
                    )
            
                  ],
                ),
              ),
            ),
          )
    );
  }
}
