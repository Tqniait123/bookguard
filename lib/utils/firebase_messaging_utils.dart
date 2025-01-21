import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'constants.dart';

//region Handle Background Firebase Message
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp().then((value) {}).catchError((e) {});
}
//endregion

Future<void> initFirebaseMessaging() async {
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    provisional: false,
    sound: true,
  );

  FirebaseMessaging.instance.setAutoInitEnabled(true).then((value) {
    FirebaseMessaging.onMessage.listen((message) async {
      if (message.notification != null && message.notification!.title.validate().isNotEmpty && message.notification!.body.validate().isNotEmpty) {
        log("---------------- Notification Data -------------------");
        log('NOTIFICATION_DATA: ${message.data}');
        showNotification(currentTimeStamp(), message.notification!.title.validate(), message.notification!.body.validate(), message);
      }
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  });

  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
}

Future<void> subscribeToFirebaseTopic() async {
  if (appStore.isLoggedIn) {
    await initFirebaseMessaging();

    if (Platform.isIOS) {
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();

      if (apnsToken != null) {
        await FirebaseMessaging.instance.subscribeToTopic('user_${appStore.userId}');
        await FirebaseMessaging.instance.subscribeToTopic(FIREBASE_APP_TAG);
      } else {
        await Future<void>.delayed(const Duration(seconds: 3));
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken != null) {
          await FirebaseMessaging.instance.subscribeToTopic('user_${appStore.userId}');
          await FirebaseMessaging.instance.subscribeToTopic(FIREBASE_APP_TAG);
        }
      }
    } else {
      await FirebaseMessaging.instance.subscribeToTopic('user_${appStore.userId}');
      await FirebaseMessaging.instance.subscribeToTopic(FIREBASE_APP_TAG);
    }
    log("============================= Topic Subscription =============================");

    log("topic-----subscribed----> user_${appStore.userId}");
    log("topic-----subscribed----> $FIREBASE_APP_TAG");
    log("FCM token: ${await FirebaseMessaging.instance.getToken()}");
  }
}

Future<void> unsubscribeFirebaseTopic() async {
  log("-------------------- unSubscribing Topic ------------------");
  await FirebaseMessaging.instance.unsubscribeFromTopic('user_${appStore.userId}').whenComplete(() {
    log("topic-----unSubscribed----> user_${appStore.userId}");
  });
  await FirebaseMessaging.instance.unsubscribeFromTopic(FIREBASE_APP_TAG).whenComplete(() {
    log("topic-----unSubscribed----> $FIREBASE_APP_TAG");
  });
}

void handleNotificationClick(RemoteMessage message) {
  // add your notification logic
  log("Messages: ${jsonEncode(message)}");
}

void showNotification(int id, String title, String message, RemoteMessage remoteMessage) async {
  log(title);
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  //code for background notification channel
  AndroidNotificationChannel channel = AndroidNotificationChannel(
    'notification',
    'Notification',
    importance: Importance.high,
    enableLights: true,
    playSound: true,
  );

  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@drawable/ic_stat_ic_notification');
  var iOS = const DarwinInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );
  var macOS = iOS;
  final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: iOS, macOS: macOS);
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (details) {
      handleNotificationClick(remoteMessage);
    },
  );

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'notification',
    'Notification',
    importance: Importance.high,
    visibility: NotificationVisibility.public,
    autoCancel: true,
    //color: primaryColor,
    playSound: true,
    priority: Priority.high,
    icon: '@drawable/ic_stat_ic_notification',
  );

  var darwinPlatformChannelSpecifics = const DarwinNotificationDetails();

  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: darwinPlatformChannelSpecifics,
    macOS: darwinPlatformChannelSpecifics,
  );

  flutterLocalNotificationsPlugin.show(id, title, message, platformChannelSpecifics);
}
