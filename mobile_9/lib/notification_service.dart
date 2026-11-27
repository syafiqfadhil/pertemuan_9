import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile_9/firebase_options.dart';
import 'package:mobile_9/notification_detail_screen.dart';

/// Kunci global Navigator, supaya kita bisa pindah halaman
/// dari luar widget (misalnya saat notifikasi di-klik).
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// HANDLER BACKGROUND / TERMINATED
/// - Wajib fungsi top-level (di luar class).
/// - Wajib diberi @pragma('vm:entry-point') agar tidak dibuang saat build release.
/// - Dipanggil saat pesan masuk ketika aplikasi di background / mati.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('[FCM] Pesan BACKGROUND: ${message.messageId}');
  debugPrint('[FCM] Data: ${message.data}');
  // Catatan: notifikasi di system tray sudah ditampilkan otomatis oleh
  // Android jika payload memiliki bagian "notification".
}

class NotificationService {
  NotificationService._();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotif =
      FlutterLocalNotificationsPlugin();

  /// Channel Android (Android 8+ wajib punya channel).
  /// ID ini HARUS sama dengan yang ada di AndroidManifest.xml
  /// dan di payload Postman ("channel_id").
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'Notifikasi Penting', // nama yang terlihat di pengaturan HP
    description: 'Channel untuk notifikasi dari Firebase Cloud Messaging',
    importance: Importance.max,
  );

  static Future<void> init() async {
    // 1. Minta izin notifikasi (Android 13+ akan muncul dialog izin)
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('[FCM] Status izin: ${settings.authorizationStatus}');

    // 2. Inisialisasi flutter_local_notifications + buat channel
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _localNotif.initialize(
      settings: const InitializationSettings(android: androidInit),
      // Dipanggil saat notifikasi LOKAL (foreground) di-klik
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          _openDetail(jsonDecode(response.payload!) as Map<String, dynamic>);
        }
      },
    );
    await _localNotif
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

}
}
