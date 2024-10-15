import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/task.dart';
import 'package:timezone/timezone.dart' as tz;

class TaskService {
  final List<Task> _tasks = [];
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  TaskService() {
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: null,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    
    // สร้าง Notification Channel สำหรับ Android 8.0 ขึ้นไป
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'task_channel_id', // Channel ID
      'Task Notifications', // Channel Name
      description: 'Notifications for task reminders',
      importance: Importance.max,
      //priority: Priority.high,
    );

    await _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  }

  List<Task> getTasks() {
    return _tasks;
  }

  void addTask(String title, String category , DateTime deadline) {
    final newTask = Task(
      id: DateTime.now().toString(),
      title: title,
      category: category,
      deadline: deadline
    );
    _tasks.add(newTask);
  }

  void toggleTaskStatus(String id) {
    final task = _tasks.firstWhere((task) => task.id == id);
    task.isCompleted = !task.isCompleted;
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
  }

  Future<void> scheduleTask(String title, DateTime scheduledDateTime) async {
    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(scheduledDateTime, tz.local);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      'Reminder: $title',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel_id', // Channel ID
          'Task Notifications', // Channel Name
          channelDescription: 'Notifications for task reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
     // androidAllowWhileIdle: true, // Allow notification when the device is idle
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime, // เปลี่ยนเป็น absoluteTime
    );
  }
}
