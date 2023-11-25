import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miniproject/components/imagetile.dart';
import 'package:miniproject/components/mybutton.dart';
import 'package:miniproject/components/mytextfield.dart';
import 'package:miniproject/screens/email_exist_google.dart';
import 'package:miniproject/screens/forgot_pw_page.dart';
import 'package:miniproject/screens/google_register.dart';
import 'package:miniproject/services/authservice.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usrnameController = TextEditingController();

  final _pswrdController = TextEditingController();

  final GoogleAuthService as = GoogleAuthService();

  final GitHubAuthService gs = GitHubAuthService();

  @override
  void dispose(){
    _usrnameController.dispose();
    _pswrdController.dispose();
    super.dispose();
  }

  Future signInWithGoogle() async {
    showDialog(
        context: context,
        builder: (context){
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
    await as.setGUser();

    int a = await as.checkUserStat();

    Navigator.pop(context);

    if(a==-1){}
    else if(a==0){
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context){
            return AuthRegisterPage(email: as.getUserEmail(), as: as);
          }
          )
        );
    }
    else if(a==1){
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context){
            return EmailExistAuth(email: as.getUserEmail(), authService: as);
          }
          )
        );
    }
    else{
      showDialog(
        context: context,
        builder: (context){
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      await as.signInWithGoogle();
      Navigator.pop(context);
    }

    // as.gUsersOut();
  }

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
        email: _usrnameController.text.trim(), 
        password: _pswrdController.text.trim()
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
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height:30),
          
                //logo
                Icon(
                  Icons.android,
                  size: 100,
                  color: Colors.green,
                ),

                Text(
                  "SDN Login",
                  style: GoogleFonts.bebasNeue(fontSize: 52, color: Colors.white),
                ),
          
                SizedBox(height: 30),
                //welcome back
                Text(
                  "Welcome back you\'ve been missed!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
          
                SizedBox(height: 30),
          
                //username
                MyTextField(controller: _usrnameController, hintText: "Email", obscureText: false),
                
                SizedBox(height: 15),
                //password
                MyTextField(controller: _pswrdController, hintText: "Password", obscureText: true),
          
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
          
                SizedBox(height: 40),
                //or continue via following options
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey.shade600,
                      ),
                    ),
          
                    Text(
                      " Or Continue With ",
                      style: TextStyle(color: Colors.white),
                      ),
          
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                  
                SizedBox(height: 30),
                //google and outlook
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageTile(imagepath: "lib/images/google.png", onTap: signInWithGoogle),
                    const SizedBox(width: 15),
                    ImageTile(imagepath: "lib/images/outlook.png", onTap: (){dynamic value = gs.githubSignIn(context); print(value);})
                  ],
                ),
          
                //not a member? register
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Not a member?", style: TextStyle(color: Colors.white)),
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