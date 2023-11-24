
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:miniproject/components/mytextfield.dart';
import 'package:miniproject/services/authservice.dart';

class EmailExistGoogle extends StatefulWidget {
  final String? email;
  final AuthService? authService;
  const EmailExistGoogle({super.key, required this.email, required this.authService});

  @override
  State<EmailExistGoogle> createState() => _EmailExistGoogleState();
}

class _EmailExistGoogleState extends State<EmailExistGoogle> {
  final _authpassController = TextEditingController();
  
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
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        foregroundColor: Colors.grey.shade300,
        leading: BackButton(onPressed: (){Navigator.pop(context); widget.authService!.gUsersOut();}),
        
      ),
      body:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("An account already exists with the same email. To link both the accounts, please enter the password.", style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 15),
            MyTextField(controller: _authpassController, hintText: "Password", obscureText: true),
            SizedBox(height: 15),
            GestureDetector(
                onTap: () async {
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
                          email: widget.authService!.getUserEmail(), 
                          password: _authpassController.text
                        );
                        widget.authService!.GooglesignInAndLink(widget.email!, _authpassController.text.trim());
                        Navigator.pop(context);
                        Navigator.pop(context);
                      } on FirebaseAuthException catch (e){
                        Navigator.pop(context);
                        if(e.code == 'wrong-password'){
                          wrongPassAlert();
                        }
                      }
                  },
                child: Container(
                  padding: EdgeInsets.all(25),
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(15),
                    ),
                  child: Center(
                    child: Text(
                      "Link",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
          ]
        ),
      );
  }
}