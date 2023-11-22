import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:miniproject/components/imagetile.dart';
import 'package:miniproject/components/mybutton.dart';
import 'package:miniproject/components/mytextfield.dart';
import 'package:miniproject/screens/forgot_pw_page.dart';
import 'package:miniproject/services/authservice.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usrnameController = TextEditingController();

  final pswrdController = TextEditingController();

  void signUserIn () async {
    showDialog(
      context: context,
      builder: (context){
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try{
      
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usrnameController.text, 
        password: pswrdController.text
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e){
      Navigator.pop(context);
      if(e.code == 'user-not-found'){
        wrongEmailAlert();
      }
      else if(e.code == 'wrong-password'){
        wrongPassAlert();
      }
    }

  }

  void wrongEmailAlert(){
    showDialog(
      context: context,
      builder: (context){
        return const AlertDialog(
          title: Text("User Does not Exist!"),
        );
      },
    );
  }

    void wrongPassAlert(){
    showDialog(
      context: context,
      builder: (context){
        return const AlertDialog(
          title: Text("Incorrect Password!"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height:40),
          
                //logo
                Icon(
                  Icons.lock,
                  size: 100,
                ),
          
                SizedBox(height: 70),
                //welcome back
                Text(
                  "Welcome back you\'ve been missed!",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
          
                SizedBox(height: 30),
          
                //username
                MyTextField(controller: usrnameController, hintText: "Email", obscureText: false),
                
                SizedBox(height: 15),
                //password
                MyTextField(controller: pswrdController, hintText: "Password", obscureText: true),
          
                SizedBox(height: 15),
                //forgot password
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context){
                          return ForgotPasswordPage();
                        }
                        )
                      );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    ),
                ),
          
                SizedBox(height: 30),
                //sign in button
                MyButton(onTap: signUserIn, text: "Sign In"),
          
                SizedBox(height: 70),
                //or continue via following options
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey.shade400,
                      ),
                    ),
          
                    Text(
                      "Or Continue With",
                      style: TextStyle(color: Colors.grey.shade700),
                      ),
          
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
                  
                SizedBox(height: 30),
                //google and outlook
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageTile(imagepath: "lib/images/google.png", onTap: AuthService().signInWithGoogle),
                    const SizedBox(width: 15),
                    ImageTile(imagepath: "lib/images/outlook.png", onTap:  (){})
                  ],
                ),
          
                //not a member? register
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Not a member?"),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Register Now",
                        style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
          
              ],
              ),
          ) 
          ),
      ),
    );
  }
}