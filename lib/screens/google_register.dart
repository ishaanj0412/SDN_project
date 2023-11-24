import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miniproject/components/mybutton.dart';
import 'package:miniproject/components/mytextfield.dart';
import 'package:miniproject/services/authservice.dart';

class GoogleRegisterPage extends StatefulWidget {
  final String? email;
  final AuthService? as;
  GoogleRegisterPage({super.key, required this.email, required this.as});

  @override
  State<GoogleRegisterPage> createState() => _GoogleRegisterPageState();
}

class _GoogleRegisterPageState extends State<GoogleRegisterPage> {
  final _usrnameController = TextEditingController();

  final _pswrdController = TextEditingController();

  final _cnfrmpswrdController = TextEditingController();

  final _firstnmController = TextEditingController();

  final _lastnmController = TextEditingController();

  final _ageController = TextEditingController();

  @override
  void initState(){
    super.initState();
    _usrnameController.text = widget.email!;
  }

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
        await widget.as?.GooglesignInAndLink(_usrnameController.text.trim(), _pswrdController.text.trim());

        addUserDetails(
          FirebaseAuth.instance.currentUser!.uid,
          _firstnmController.text.trim(),
          _lastnmController.text.trim(),
          _usrnameController.text.trim(),
          int.parse(_ageController.text.trim())
        );
        Navigator.pop(context);
        Navigator.pop(context);
      }
      else{
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
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        foregroundColor: Colors.grey.shade300,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height:30),
          
                //logo
                Text(
                  "Welcome",
                  style: GoogleFonts.bebasNeue(fontSize: 52),
                ),
          
                SizedBox(height:10),
                //welcome back
                Text(
                  "Please enter your details",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
          
                SizedBox(height: 30),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      controller: _usrnameController,
                      obscureText: false,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: "Email",
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                      ),
                    ),
                  ),
                
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
          
              ],
              ),
          ) 
          ),
      ),
    );
  }
}