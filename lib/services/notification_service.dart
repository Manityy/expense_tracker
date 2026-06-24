import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);
    _initialized = true;
  }

  Future<bool> requestPermission() async {
    await initialize();

    if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final granted = await android?.requestNotificationsPermission();
      return granted ?? false;
    }

    if (Platform.isIOS) {
      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      final granted = await ios?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return true;
  }

  Future<bool> _shouldNotify(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final storageKey = 'notif_$key';
    if (prefs.getString(storageKey) == today) return false;
    await prefs.setString(storageKey, today);
    return true;
  }

  Future<void> showBudgetAlert({
    required String category,
    required double spent,
    required double limit,
  }) async {
    if (!await _shouldNotify('budget_$category')) return;
    await _show(
      id: category.hashCode,
      title: '⚠️ $category budget alert',
      body:
          'You\'ve spent ${spent.toStringAsFixed(0)} DT of your ${limit.toStringAsFixed(0)} DT $category budget.',
    );
  }

  Future<void> showSubscriptionDue({
    required String title,
    required double amount,
    required int daysLeft,
  }) async {
    if (!await _shouldNotify('sub_${title}_$daysLeft')) return;
    final when = daysLeft == 0
        ? 'today'
        : daysLeft == 1
            ? 'tomorrow'
            : 'in $daysLeft days';
    await _show(
      id: title.hashCode,
      title: '🔔 Subscription due $when',
      body: '$title — ${amount.toStringAsFixed(0)} DT',
    );
  }

  Future<void> showChallengeCompleted(String challengeTitle) async {
    if (!await _shouldNotify('challenge_$challengeTitle')) return;
    await _show(
      id: challengeTitle.hashCode,
      title: '🏆 Challenge completed!',
      body: 'You finished "$challengeTitle". Keep it up!',
    );
  }

  Future<void> _show({
    required int id,
    required String title,
    required String body,
  }) async {
    if (!_initialized) return;

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'flousi_alerts',
        'Flousi Alerts',
        channelDescription: 'Budget, subscription, and challenge alerts',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.show(id, title, body, details);
  }
}
