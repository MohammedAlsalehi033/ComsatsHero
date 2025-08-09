import 'package:comsats_hero/models/users.dart';
import 'package:comsats_hero/screens/MainScreen.dart';
import 'package:comsats_hero/screens/Profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyFireBaseAuth {
  static Future<void> signInWithGoogle(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // If user is already signed in, navigate to MainScreen directly
        Navigator.of(context, rootNavigator: true).pop(); // Dismiss the loading indicator
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
        print("User signed in: ${currentUser.displayName} (${currentUser.email})");

        return;
      }

      // Initialize GoogleSignIn
      final GoogleSignInAccount? googleSignInAccount =
      await GoogleSignIn().signIn();

      if (googleSignInAccount == null) {
        // The user canceled the sign-in process
        Navigator.of(context, rootNavigator: true).pop(); // Dismiss the loading indicator
        return;
      }

      // Obtain the GoogleSignInAuthentication object
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      // Create a new credential using the GoogleSignInAuthentication object
      final OAuthCredential googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      // Sign in to Firebase with the Google Auth credentials
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(googleAuthCredential);

      // Print user information to the console
      final User user = userCredential.user!;
      print("User signed in: ${user.displayName} (${user.email})");

      final userInFirebase = await UserService.getUser(user.email!);
      Navigator.of(context, rootNavigator: true).pop(); // Dismiss the loading indicator

      if (!userInFirebase.exists) {
        UserService.createUser(user.email!, user.displayName!, user.email!, "");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Profile()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      }

    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop(); // Dismiss the loading indicator
      print("Error during Google sign in: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error during Google sign in: $e")),
      );
    }
  }
}
