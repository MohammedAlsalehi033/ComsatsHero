import 'package:camera/camera.dart';
import 'package:comsats_hero/screens/MainScreen.dart';
import 'package:comsats_hero/services/firebasePushNotifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'screens/LoginScreen.dart';

List<CameraDescription> cameras = [];

Future<void> handler(RemoteMessage message) async {
  print(message.notification!.body!.toString());
}

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();

  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print(e.code);
  }

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.env['API_KEY']!,
      appId: dotenv.env['APP_ID']!,
      messagingSenderId: dotenv.env['MESSAGING_SENDER_ID']!,
      projectId: dotenv.env['PROJECT_ID']!,
      storageBucket: dotenv.env['STORAGE_BUCKET']!,
    ),
  );

  User? currentUser = FirebaseAuth.instance.currentUser;

  await NotificationService.initialize();



  runApp(MyApp(currentUser: currentUser));
}

class MyApp extends StatelessWidget {
  final User? currentUser;

  MyApp({this.currentUser});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          home: currentUser == null ? SignningWidget() : MainScreen(),
        );
      },
    );
  }
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
