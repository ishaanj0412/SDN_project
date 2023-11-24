import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:miniproject/components/mybutton.dart';
import 'package:miniproject/components/mytextfield.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  
  final emailController = TextEditingController();

  @override
  void dispose(){
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset(String email) async {
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Password reset link sent!"),
          );
        },
      );
    } on FirebaseAuthException catch(e){
      print(e);
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text(e.message.toString()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        foregroundColor: Colors.grey.shade300,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Enter your email for a password reset link", 
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
            ),
            ),
          SizedBox(height: 30),
          MyTextField(controller: emailController, hintText: "Email", obscureText: false),
          SizedBox(height: 30),
          MyButton(onTap: (){passwordReset(emailController.text.trim());}, text: "Reset Password")
        ],
      )
    );
  }
}