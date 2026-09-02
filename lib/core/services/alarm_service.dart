import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'tts_service.dart';

@pragma('vm:entry-point')
void alarmCallback(int id) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  var box = await Hive.openBox('alarms_box');
  
  String alarmMessage = box.get(id, defaultValue: "Alarm Time!");

  await TTSService.initTTS();
  await TTSService.speakLoop(alarmMessage);
}

class AlarmService {
  static Future<void> init() async {
    await AndroidAlarmManager.initialize();
  }

  static Future<void> scheduleAlarm({
    required int alarmId,
    required DateTime targetTime,
    required String customMessage,
  }) async {
    var box = Hive.box('alarms_box');
    await box.put(alarmId, customMessage);

    await AndroidAlarmManager.oneShotAt(
      targetTime,
      alarmId,
      alarmCallback,
      exact: true,
      wakeup: true,
      alarmClock: true,
    );
  }

  static Future<void> cancelAlarm(int alarmId) async {
    await AndroidAlarmManager.cancel(alarmId);
    await TTSService.stop();
  }
}
