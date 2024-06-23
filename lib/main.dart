import 'package:camera/camera.dart';
import 'package:comsats_hero/screens/MainScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/LoginScreen.dart';



List<CameraDescription> cameras = [];

void main() async{




  WidgetsFlutterBinding.ensureInitialized();

  try {
    cameras = await availableCameras();

  } on CameraException catch (e) {
    print(e.code);
  }

  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDoAMmPXkEAduFxccg0M38UycWyHXGwJAs',
        appId: '1:819269999687:android:fa4f60e6359f8dcaa0a562',
        messagingSenderId: '819269999687',
        projectId: 'comsatshero',
        storageBucket: 'comsatshero.appspot.com',
      ));

  User? currentUser = FirebaseAuth.instance.currentUser;


  runApp(currentUser == null ? SignningWidget() : MainClass());
}

class MainClass extends StatefulWidget {
  const MainClass({super.key});

  @override
  State<MainClass> createState() => _MainClassState();
}

class _MainClassState extends State<MainClass> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MainScreen());
  }
}
