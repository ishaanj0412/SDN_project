import 'package:firebase_auth/firebase_auth.dart';
import 'package:github_signin_promax/github_signin_promax.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:miniproject/screens/email_exist_google.dart';
import 'dart:convert';

import 'package:miniproject/screens/google_register.dart';

class GoogleAuthService{
  GoogleSignInAccount? gUser;

  Future <dynamic> signInWithGoogle() async{
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final cred = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    gUsersOut();

    return await FirebaseAuth.instance.signInWithCredential(cred);
  }

  Future <dynamic> setGUser() async{
    gUser = await GoogleSignIn().signIn();
  }

  Future <int> checkUserStat() async{
    if(gUser==null) return -1;

    String usrEm = gUser!.email;

    dynamic signInmeth = await FirebaseAuth.instance.fetchSignInMethodsForEmail(usrEm);
    
    if(signInmeth.length == 0){
      return 0;
    }
    else if(signInmeth.length > 0 && !signInmeth.contains("google.com")){
      return 1;
    }

    return 2;
  }

  Future <dynamic> gUsersOut() async{
    gUser = await GoogleSignIn().signOut();
  }

  String getUserEmail(){
    return gUser!.email;
  }

  Future <dynamic> signInAndLink(String email, String password) async{
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final cred = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    gUsersOut();
    
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, 
          password: password,
        );
    } on FirebaseAuthException {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    }

    try {
      await FirebaseAuth.instance.currentUser
          ?.linkWithCredential(cred);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          print("The provider has already been linked to the user.");
          break;
        case "invalid-credential":
          print("The provider's credential is not valid.");
          break;
        case "credential-already-in-use":
          print("The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User.");
          break;
        // See the API reference for the full list of error codes.
        default:
          print("Unknown error.");
      }
    }
  }
}

class GitHubAuthService{
  dynamic accessToken;
  String? email;  

  Future <dynamic> githubSignIn(BuildContext context) async{

    var params = GithubSignInParams(
      clientId: 'c51b9f2e4e65e4589553',
      clientSecret: '7c480f35bebed7d7800d645327ec8ea1ee835ee1',
      redirectUrl: 'https://sdn-final-a2d81.firebaseapp.com/__/auth/handler',
      scopes: 'read:user,user:email',
    );

    Navigator.of(context).push(MaterialPageRoute(builder: (builder) {
      return GithubSigninScreen(
        params: params,
        headerColor: Colors.black,
        title: 'Login with github',
      );
    })).then((value) async {
      this.accessToken = value.accessToken;
      String? email = await fetchUserEmail(value.accessToken);
      this.email = email;
      int resp = await checkUserStat(email!);
      showDialog(
          context: context,
          builder: (context){
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      if(resp==2){
        AuthCredential credential = GithubAuthProvider.credential(value.accessToken);
        await FirebaseAuth.instance.signInWithCredential(credential);
        Navigator.pop(context);
      }
      else if(resp==0){
        Navigator.pop(context);
        Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context){
            return AuthRegisterPage(email: email, as: this);
          }
          )
        );
      }
      else if(resp==1){
        Navigator.pop(context);
        Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context){
            return EmailExistAuth(email: email, authService: this);
          }
          )
        );
      }
      
    });
  }

    Future<dynamic> fetchUserEmail(String accessToken) async {
    final response = await http.get(
      Uri.https('api.github.com', '/user/emails'),
      headers: {
        'Authorization': 'token $accessToken',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      String? em = extractEmails(response.body);
      return em;
    } else {
      print('Failed to fetch user email: ${response.statusCode}');
      return null;
    }
  }

  dynamic extractEmails(String responseBody) {
    List<dynamic> emails = jsonDecode(responseBody);

    var primaryEmailObj = emails.firstWhere((emailObj) => emailObj['primary'] == true,
        orElse: () => null);

    if (primaryEmailObj != null) {
      String primaryEmail = primaryEmailObj['email'];
      return primaryEmail;
    }

    return null;
  }

  Future <int> checkUserStat(String email) async{

    String usrEm = email;

    dynamic signInmeth = await FirebaseAuth.instance.fetchSignInMethodsForEmail(usrEm);
    
    if(signInmeth.length == 0){
      return 0;
    }
    else if(signInmeth.length > 0 && !signInmeth.contains("github.com")){
      return 1;
    }

    return 2;
  }

  Future <dynamic> signInAndLink(String email, String password) async{
    AuthCredential credential = GithubAuthProvider.credential(accessToken);
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, 
          password: password,
        );
    } on FirebaseAuthException catch (e){
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    }

    try {
      await FirebaseAuth.instance.currentUser
          ?.linkWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          print("The provider has already been linked to the user.");
          break;
        case "invalid-credential":
          print("The provider's credential is not valid.");
          break;
        case "credential-already-in-use":
          print("The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User.");
          break;
        // See the API reference for the full list of error codes.
        default:
          print("Unknown error.");
      }
    }
  }

  String getUserEmail(){
    return email!;
  }
}