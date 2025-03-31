import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';
import 'dart:async';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;
  
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  
  NotificationService._();
  
  Future<void> initialize() async {
    try {
      if (_initialized) return;
      
      tz.initializeTimeZones();
      
      const androidChannel = AndroidNotificationChannel(
        'meditation_reminders',
        'Meditation Reminders',
        description: 'Daily meditation reminder notifications',
        importance: Importance.max,
        enableVibration: true,
        playSound: true,
        showBadge: true,
      );

      final initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
      final initializationSettingsIOS = const DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        defaultPresentAlert: true,
        defaultPresentBadge: true,
        defaultPresentSound: true,
      );

      final initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      final success = await _notifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('Notification clicked: ${response.payload}');
        },
      );

      debugPrint('Notifications initialized: $success');

      // Create the Android notification channel
      final androidSuccess = await _notifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);
      
      // debugPrint('Android channel created: $androidSuccess');

      // Request iOS permissions
      final iOSSuccess = await _notifications
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
            critical: true,
          );
      
      debugPrint('iOS permissions granted: $iOSSuccess');
      
      _initialized = true;
    } catch (e, stackTrace) {
      debugPrint('Error initializing notifications: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  Future<void> scheduleNotification(TimeOfDay time) async {
    try {
      if (!_initialized) {
        debugPrint('Initializing notifications service...');
        await initialize();
      }
      
      debugPrint('Cancelling existing notifications...');
      await _notifications.cancelAll();

      final now = DateTime.now();
      var scheduledDate = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      debugPrint('Current time: ${now.toString()}');
      debugPrint('Scheduled time: ${scheduledDate.toString()}');

      // For testing purposes, schedule multiple notifications
      final difference = scheduledDate.difference(now).inMinutes;
      debugPrint('Time difference in minutes: $difference');

      final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'meditation_reminders',
          'Meditation Reminders',
          channelDescription: 'Daily meditation reminder notifications',
          importance: Importance.max,
          priority: Priority.high,
          enableVibration: true,
          vibrationPattern: Int64List.fromList([0, 500, 200, 500]), // Vibration pattern
          playSound: true,
          sound: const RawResourceAndroidNotificationSound('notification_sound'),
          category: AndroidNotificationCategory.alarm,
          fullScreenIntent: true,
          visibility: NotificationVisibility.public,
          channelShowBadge: true,
          styleInformation: const BigTextStyleInformation(
            'Take a moment to find peace and tranquility through meditation. Your daily practice awaits.',
            contentTitle: '🧘‍♀️ Time for Meditation',
            summaryText: 'Daily Meditation Reminder',
          ),
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          sound: 'notification_sound.aiff',
          interruptionLevel: InterruptionLevel.timeSensitive,
          threadIdentifier: 'meditation',
          categoryIdentifier: 'meditation_category',
          subtitle: 'Daily Practice',
          badgeNumber: 1,
        ),
      );

      if (difference <= 5) {
        await _notifications.show(
          0,
          '🧘‍♀️ Time for Meditation',
          'Take a moment to find peace and tranquility through meditation. Your daily practice awaits.',
          notificationDetails,
        );
      }

      // Schedule the daily notification
      await _notifications.zonedSchedule(
        2,
        '🧘‍♀️ Time for Meditation',
        'Take a moment to find peace and tranquility through meditation. Your daily practice awaits.',
        tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      // Add a periodic check for upcoming notifications
      Timer.periodic(const Duration(minutes: 1), (timer) {
        final now = DateTime.now();
        final remainingMinutes = scheduledDate.difference(now).inMinutes;
        debugPrint('Time until next notification: $remainingMinutes minutes');
        
        if (remainingMinutes <= 0) {
          debugPrint('Notification time reached!');
          timer.cancel();
        }
      });

      final pendingNotifications = await _notifications.pendingNotificationRequests();
      debugPrint('Number of pending notifications: ${pendingNotifications.length}');
      for (var notification in pendingNotifications) {
        debugPrint('Pending notification ID: ${notification.id}');
      }

    } catch (e, stackTrace) {
      debugPrint('Error scheduling notification: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}