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
    apiKey: 'AIzaSyCvUzjE-Le48EfF-RnpzC3jQJDth_z07ng',
    appId: '1:16793254625:web:f98a9bde1db0d700b7d5a0',
    messagingSenderId: '16793254625',
    projectId: 'bookstore-a639b',
    authDomain: 'bookstore-a639b.firebaseapp.com',
    storageBucket: 'bookstore-a639b.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAjKLmzbPyABpliaZmdwyZoHjEJ56r4iHc',
    appId: '1:16793254625:android:284f371777c1fb71b7d5a0',
    messagingSenderId: '16793254625',
    projectId: 'bookstore-a639b',
    storageBucket: 'bookstore-a639b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCQ5itzNs-xr25T7gAavxISPzwu3Xbv1dc',
    appId: '1:16793254625:ios:10299d286835f37bb7d5a0',
    messagingSenderId: '16793254625',
    projectId: 'bookstore-a639b',
    storageBucket: 'bookstore-a639b.appspot.com',
    iosBundleId: 'com.example.kutuphaneProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCQ5itzNs-xr25T7gAavxISPzwu3Xbv1dc',
    appId: '1:16793254625:ios:b5c00ea722543b4eb7d5a0',
    messagingSenderId: '16793254625',
    projectId: 'bookstore-a639b',
    storageBucket: 'bookstore-a639b.appspot.com',
    iosBundleId: 'com.example.kutuphaneProject.RunnerTests',
  );
}
