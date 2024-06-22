import 'package:comsats_hero/screens/Profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comsats_hero/theme/Colors.dart';
import 'package:comsats_hero/main.dart';
import '../services/FireBaseAuth.dart';

class SignningWidget extends StatefulWidget {
  const SignningWidget({Key? key}) : super(key: key);

  @override
  _SignningWidgetState createState() => _SignningWidgetState();
}

class _SignningWidgetState extends State<SignningWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder:(context)=> Scaffold(backgroundColor: MyColors.backgroundColor,
            body: Center(
              child: ElevatedButton(child: Text("Sign In with Google"),onPressed: ()async{
                MyFireBaseAuth.signInWithGoogle(context);
              },),
            )),
      ),
    );
  }
}




// Future<UserCredential> signInWithFacebook() async {
//   // Trigger the sign-in flow
//   final LoginResult loginResult = await FacebookAuth.instance.login();
//
//   // Create a credential from the access token
//   final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
//
//   // Once signed in, return the UserCredential
//   return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
// }
