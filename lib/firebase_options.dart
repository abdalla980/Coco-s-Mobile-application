import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBSoxZqhhslacITgvvFO7lcYfDxVQt7fu8',
    appId: '1:916525479366:android:30a2622e2662f1f2dd6ec7',
    messagingSenderId: '916525479366',
    projectId: 'coco-app-9d908',
    storageBucket: 'coco-app-9d908.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBl9B5m-8eZE3zsW1euTrOCwNuuH0qhgUQ',
    appId: '1:916525479366:ios:1fd2c41cd0f77c53dd6ec7',
    messagingSenderId: '916525479366',
    projectId: 'coco-app-9d908',
    storageBucket: 'coco-app-9d908.firebasestorage.app',
    iosBundleId: 'com.example.cocosMobileApplication',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBSoxZqhhslacITgvvFO7lcYfDxVQt7fu8',
    appId: '1:916525479366:web:your-web-app-id',
    messagingSenderId: '916525479366',
    projectId: 'coco-app-9d908',
    authDomain: 'coco-app-9d908.firebaseapp.com',
    storageBucket: 'coco-app-9d908.firebasestorage.app',
  );
}
