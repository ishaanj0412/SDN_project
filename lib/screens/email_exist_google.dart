
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:miniproject/components/mytextfield.dart';

class EmailExistAuth extends StatefulWidget {
  final String? email;
  final dynamic authService;
  const EmailExistAuth({super.key, required this.email, required this.authService});

  @override
  State<EmailExistAuth> createState() => _EmailExistAuthState();
}

class _EmailExistAuthState extends State<EmailExistAuth> {
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
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        elevation: 0,
        foregroundColor: Colors.white,
        leading: BackButton(onPressed: (){Navigator.pop(context); widget.authService!.gUsersOut();}),
        
      ),
      body:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Text("An account already exists with the same email. To link both the accounts, please enter the password.", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
                        widget.authService!.signInAndLink(widget.email!, _authpassController.text.trim());
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
                    color: const Color.fromARGB(255, 71, 39, 126),
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