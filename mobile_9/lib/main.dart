import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mobile_9/firebase_options.dart';
import 'package:mobile_9/notification_service.dart';
import 'package:mobile_9/screens/login_page.dart';
import 'package:mobile_9/screens/user_info_screen.dart';
import 'package:mobile_9/widgets/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Handler untuk pesan saat aplikasi di background / mati
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Inisialisasi notifikasi (izin, channel, token, listener)
  await NotificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Auth & FCM',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}
