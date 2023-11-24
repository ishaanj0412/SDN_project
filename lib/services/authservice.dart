import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{
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
    else if(signInmeth.length == 1 && signInmeth[0] == "password"){
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

  Future <dynamic> GooglesignInAndLink(String email, String password) async{
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final cred = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(cred);


    gUsersOut();
    try{
      await FirebaseAuth.instance.currentUser?.updatePassword(password);
      return true;
    }
    catch(e){
      print(e);
      return false;
    }
  }
}