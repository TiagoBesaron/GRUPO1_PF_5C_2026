import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions no están configuradas para esta plataforma.',
        );
    }
  }

  // REEMPLAZÁ CON TUS DATOS REALES DE FIREBASE
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDAb20RirfjHs3jMZxcpdGk-aANP6w4cV0',
    appId: '1:137210611479:web:9268a37d937dc6af4d5952',
    messagingSenderId: '137210611479',
    projectId: 'activelo-d9b08',
    databaseURL: 'https://activelo-d9b08-default-rtdb.firebaseio.com/',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDAb20RirfjHs3jMZxcpdGk-aANP6w4cV0',
    appId: '1:137210611479:web:9268a37d937dc6af4d5952',
    messagingSenderId: '137210611479',
    projectId: 'activelo-d9b08',
    databaseURL: 'https://activelo-d9b08-default-rtdb.firebaseio.com/',
  );
}