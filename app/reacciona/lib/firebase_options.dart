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
    apiKey: 'AIzaSyB1vdZWLxmgbU74BZwmHlV9ll1zAFuy1Sk',
    appId: '1:481993883697:web:b141465562871624605510',
    messagingSenderId: '481993883697',
    projectId: 'g1-pf-5c-2026',
    databaseURL: 'https://tu-proyecto-id-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB1vdZWLxmgbU74BZwmHlV9ll1zAFuy1Sk',
    appId: '1:481993883697:web:b141465562871624605510',
    messagingSenderId: '481993883697',
    projectId: 'g1-pf-5c-2026',
    databaseURL: 'https://tu-proyecto-id-default-rtdb.firebaseio.com',
  );
}
