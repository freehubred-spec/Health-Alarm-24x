import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  runApp(const HealthAlarmApp());
}

class HealthAlarmApp extends StatelessWidget {
  const HealthAlarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health Alarm 24x',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const AlarmHomePage(),
    );
  }
}

class AlarmHomePage extends StatefulWidget {
  const AlarmHomePage({super.key});

  @override
  State<AlarmHomePage> createState() => _AlarmHomePageState();
}

class _AlarmHomePageState extends State<AlarmHomePage> {
  List<AlarmSettings> _alarms = [];

  @override
  void initState() {
    super.initState();
    _loadAlarms();
  }

  void _loadAlarms() {
    setState(() {
      _alarms = Alarm.getAlarms();
    });
  }

  void _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      _showTitleDialog(picked);
    }
  }

  void _showTitleDialog(TimeOfDay time) {
    TextEditingController controller = TextEditingController(text: 'Medicine Reminder');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Alarm Label'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'e.g., Water, Medicine, Gym',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _setAlarm(time, controller.text);
              Navigator.pop(context);
            },
            child: const Text('Save Alarm'),
          ),
        ],
      ),
    );
  }

  Future<void> _setAlarm(TimeOfDay time, String title) async {
    final now = DateTime.now();
    var alarmDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (alarmDateTime.isBefore(now)) {
      alarmDateTime = alarmDateTime.add(const Duration(days: 1));
    }

    final alarmSettings = AlarmSettings(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      dateTime: alarmDateTime,
      assetAudioPath: 'assets/alarm.mp3',
      loopAudio: true,
      vibrate: true,
      warningNotificationOnKill: true,
      androidFullScreenIntent: true,
      volumeSettings: VolumeSettings.fade(
        duration: const Duration(seconds: 2),
        volumeEnforced: true,
      ),
      notificationTitle: title,
      notificationBody: 'Health Alarm is Ringing!',
    );

    await Alarm.set(alarmSettings: alarmSettings);
    _loadAlarms();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Alarm scheduled for ${time.format(context)}')),
      );
    }
  }

  Future<void> _deleteAlarm(int id) async {
    await Alarm.stop(id);
    _loadAlarms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Alarm 24x', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: _alarms.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.alarm_off, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No Active Alarms!',
                    style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  Text('Tap + button to schedule a real alarm'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _alarms.length,
              itemBuilder: (context, index) {
                final alarm = _alarms[index];
                final TimeOfDay time = TimeOfDay.fromDateTime(alarm.dateTime);
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.alarm, color: Colors.teal, size: 36),
                    title: Text(
                      time.format(context),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(alarm.notificationTitle, style: const TextStyle(fontSize: 16)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteAlarm(alarm.id),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _pickTime,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_alarm),
        label: const Text('Add Alarm'),
      ),
    );
  }
}
