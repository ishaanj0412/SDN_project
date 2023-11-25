import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miniproject/components/mybutton.dart';
import 'package:miniproject/components/mytextfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usrnameController = TextEditingController();

  final _pswrdController = TextEditingController();

  final _cnfrmpswrdController = TextEditingController();

  final _firstnmController = TextEditingController();

  final _lastnmController = TextEditingController();

  final _ageController = TextEditingController();

  Future addUserDetails(String uid, String fn, String ln, String em, int age) async {
    await FirebaseFirestore.instance.collection('users').add({
      'uid': uid,
      'first name': fn,
      'last name': ln,
      'email': em,
      'age': age,
    });
  }

  Future signUserUp () async {
    showDialog(
      context: context,
      builder: (context){
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try{
      if(_cnfrmpswrdController.text.trim() == _pswrdController.text.trim()){
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _usrnameController.text.trim(), 
          password: _pswrdController.text.trim(),
        );

        addUserDetails(
          FirebaseAuth.instance.currentUser!.uid,
          _firstnmController.text.trim(),
          _lastnmController.text.trim(),
          _usrnameController.text.trim(),
          int.parse(_ageController.text.trim())
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
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height:30),
          
                //logo
                Text(
                  "SDN Signup",
                  style: GoogleFonts.bebasNeue(fontSize: 52, color: Colors.green),
                ),
          
                SizedBox(height:10),
                //welcome back
                Text(
                  "Let\'s create an account for you",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
          
                SizedBox(height: 30),

                MyTextField(controller: _usrnameController, hintText: "Email", obscureText: false),
                
                SizedBox(height: 10),

                MyTextField(controller: _firstnmController, hintText: "First Name", obscureText: false),
                
                SizedBox(height: 10),

                MyTextField(controller: _lastnmController, hintText: "Last Name", obscureText: false),
                
                SizedBox(height: 10),

                MyTextField(controller: _ageController, hintText: "Age", obscureText: false),
                
                SizedBox(height: 10),
           
                MyTextField(controller: _pswrdController, hintText: "Password", obscureText: true),

                SizedBox(height: 10),

                MyTextField(controller: _cnfrmpswrdController, hintText: "Confirm Password", obscureText: true),
          
                SizedBox(height: 20),

                MyButton(onTap: signUserUp, text: "Register"),
          
                SizedBox(height: 20),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already a member?", style: TextStyle(color: Colors.white)),
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