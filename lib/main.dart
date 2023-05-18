// Implement sound notifications for call, email, and message events.
// Each notification sound should be unique and easily distinguishable.
// Ensure the sound notifications work seamlessly on both iOS and Android platforms.
// The notifications should work correctly whether the app is in the foreground or background

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sound Notifications Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AudioCache audioCache = AudioCache();

  Future<void> initializeNotifications() async {
    final AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings iosSettings = IOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> playSound(String soundPath) async {
    final player = await audioCache.play(soundPath);
    await player.onPlayerCompletion.first;
  }

  Future<void> showNotification(
      String title, String body, String soundPath) async {
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      // 'channel_description',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound(soundPath),
    );
    final IOSNotificationDetails iosDetails = IOSNotificationDetails();
    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: 'default_sound',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sound Notifications Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                await initializeNotifications();
                await playSound('sounds/call_sound.mp3');
                await showNotification(
                  'Incoming Call',
                  'You have a new incoming call',
                  'sounds/call_sound.mp3',
                );
              },
              child: const Text('Test Call Notification'),
            ),
            ElevatedButton(
              onPressed: () async {
                await initializeNotifications();
                await playSound('sounds/email_sound.mp3');
                await showNotification(
                  'New Email',
                  'You have a new email',
                  'sounds/email_sound.mp3',
                );
              },
              child: const Text('Test Email Notification'),
            ),
            ElevatedButton(
              onPressed: () async {
                await initializeNotifications();
                // await playSound('assets/sounds/message_sound.mp3');
                await playSound('sounds/message_sound.mp3');
                await showNotification(
                  'New Message',
                  'You have a new message',
                  'sounds/message_sound.mp3',
                );
              },
              child: const Text('Test Message Notification'),
            ),
            // Image.asset('assets/screen_02.jpg')
          ],
        ),
      ),
    );
  }
}
