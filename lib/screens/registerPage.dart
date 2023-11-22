import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:miniproject/components/mybutton.dart';
import 'package:miniproject/components/mytextfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usrnameController = TextEditingController();

  final pswrdController = TextEditingController();

  final cnfrmpswrdController = TextEditingController();

  void signUserUp () async {
    showDialog(
      context: context,
      builder: (context){
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try{
      if(cnfrmpswrdController.text == pswrdController.text){
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: usrnameController.text, 
          password: pswrdController.text,
        );
        Navigator.pop(context);
      }
      else{
        print("ERROR");
        Navigator.pop(context);
        PassNotMatchAlert();
      }
    } on FirebaseAuthException catch (e){
      Navigator.pop(context);
      print(e.code);
      if(e.code == 'email-already-in-use'){
        EmailExistAlert();
      }
      else if(e.code == "weak-password"){
        WeakPassword();
      }
    }

  }

  void EmailExistAlert(){
    showDialog(
      context: context,
      builder: (context){
        return const AlertDialog(
          title: Text("User already exists!"),
        );
      },
    );
  }

  void WeakPassword(){
    showDialog(
      context: context,
      builder: (context){
        return const AlertDialog(
          title: Text("Weak Password!"),
        );
      },
    );
  }

  void PassNotMatchAlert(){
    showDialog(
      context: context,
      builder: (context){
        return const AlertDialog(
          title: Text("Passwords Dont Match!"),
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
                SizedBox(height:30),
          
                //logo
                Icon(
                  Icons.lock,
                  size: 60,
                ),
          
                SizedBox(height: 40),
                //welcome back
                Text(
                  "Let\'s create an account for you",
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
                //password
                MyTextField(controller: cnfrmpswrdController, hintText: "Confirm Password", obscureText: true),
          
                SizedBox(height: 15),
                //sign in button
                MyButton(onTap: signUserUp, text: "Register"),
          
                SizedBox(height: 70),
                //or continue via following options
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already a member?"),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Login Now",
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