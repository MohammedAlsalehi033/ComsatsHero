// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBdU2-8TDJWi6m6kp8u6KXf-YMDjK9XxGI',
    appId: '1:819269999687:web:69a252bf87d98e3ca0a562',
    messagingSenderId: '819269999687',
    projectId: 'comsatshero',
    authDomain: 'comsatshero.firebaseapp.com',
    databaseURL: 'https://comsatshero-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'comsatshero.appspot.com',
    measurementId: 'G-G9JW0RVRYD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDoAMmPXkEAduFxccg0M38UycWyHXGwJAs',
    appId: '1:819269999687:android:3d67ba82f5575e7ea0a562',
    messagingSenderId: '819269999687',
    projectId: 'comsatshero',
    databaseURL: 'https://comsatshero-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'comsatshero.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDtWRKV9fTiKbqJXshos2qzDaJP7fNg60c',
    appId: '1:819269999687:ios:da40c0802f33cedea0a562',
    messagingSenderId: '819269999687',
    projectId: 'comsatshero',
    databaseURL: 'https://comsatshero-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'comsatshero.appspot.com',
    androidClientId: '819269999687-fglq72as8sbgtu1fad46bdr4lobmqlsq.apps.googleusercontent.com',
    iosClientId: '819269999687-ed3c46i70l5dm4l0pdreg12u664dkpu0.apps.googleusercontent.com',
    iosBundleId: 'com.example.comsatsHero',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDtWRKV9fTiKbqJXshos2qzDaJP7fNg60c',
    appId: '1:819269999687:ios:f39427c1797af5aca0a562',
    messagingSenderId: '819269999687',
    projectId: 'comsatshero',
    databaseURL: 'https://comsatshero-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'comsatshero.appspot.com',
    androidClientId: '819269999687-fglq72as8sbgtu1fad46bdr4lobmqlsq.apps.googleusercontent.com',
    iosClientId: '819269999687-ubn7gak424p0od69tttch239pfvcm6ap.apps.googleusercontent.com',
    iosBundleId: 'com.example.comsatsHero.RunnerTests',
  );
}
