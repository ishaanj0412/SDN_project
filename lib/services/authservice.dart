import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{
  GoogleSignInAccount? gUser;

  Future <dynamic> signInWithGoogle() async{
    gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final cred = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    gUser = await GoogleSignIn().signOut();
    return await FirebaseAuth.instance.signInWithCredential(cred);
  }
}