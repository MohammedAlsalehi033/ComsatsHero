import 'package:comsats_hero/screens/Profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comsats_hero/theme/Colors.dart';
import 'package:comsats_hero/main.dart';
import 'package:provider/provider.dart';
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
    final myColors = Provider.of<MyColors>(context);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: myColors.backgroundColor,
      body: Center(
        child: ElevatedButton(
          child: Text("Sign In with Google"),
          onPressed: () async {
            await MyFireBaseAuth.signInWithGoogle(context);
          },
        ),
      ),
    );
  }
}
