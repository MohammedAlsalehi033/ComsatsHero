import 'package:camera/camera.dart';
import 'package:comsats_hero/providers/ThemeProvider.dart';
import 'package:comsats_hero/screens/MainScreen.dart';
import 'package:comsats_hero/services/firebasePushNotifications.dart';
import 'package:comsats_hero/theme/Colors.dart';
import 'package:comsats_hero/theme/Mythemes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(MyThemes.darkTheme)),
        ChangeNotifierProvider(create: (_) => MyColors()),
      ],
      child: MyApp(currentUser: currentUser,),
    ),
  );
}

class MyApp extends StatelessWidget {
  final User? currentUser;

  MyApp({this.currentUser});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      builder: (BuildContext context, Widget? child) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          theme: themeProvider.getTheme,
          home: currentUser == null ? SignningWidget() : MainScreen(),
        );
      },
    );
  }
}
