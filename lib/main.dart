import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
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
  final List<Map<String, dynamic>> _alarms = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _checkAlarms();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _checkAlarms() {
    final now = TimeOfDay.now();
    for (var alarm in _alarms) {
      if (alarm['isEnabled'] &&
          alarm['time'].hour == now.hour &&
          alarm['time'].minute == now.minute &&
          !alarm['isRinging']) {
        alarm['isRinging'] = true;
        _playAlarmSound(alarm['title']);
      }
    }
  }

  void _playAlarmSound(String title) async {
    await _audioPlayer.play(AssetSource('alarm.mp3'));
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.alarm_on, color: Colors.teal, size: 30),
              SizedBox(width: 10),
              Text('Alarm Ringing!'),
            ],
          ),
          content: Text('Time for: $title'),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
              onPressed: () async {
                await _audioPlayer.stop();
                Navigator.pop(context);
              },
              child: const Text('STOP ALARM'),
            ),
          ],
        ),
      );
    }
  }

  void _addAlarm(TimeOfDay time, String title) {
    setState(() {
      _alarms.add({
        'time': time,
        'title': title,
        'isEnabled': true,
        'isRinging': false,
      });
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
              _addAlarm(time, controller.text);
              Navigator.pop(context);
            },
            child: const Text('Save Alarm'),
          ),
        ],
      ),
    );
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
                  Text('Tap + button to set an alarm'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _alarms.length,
              itemBuilder: (context, index) {
                final alarm = _alarms[index];
                final TimeOfDay time = alarm['time'];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.alarm, color: Colors.teal, size: 36),
                    title: Text(
                      time.format(context),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(alarm['title'], style: const TextStyle(fontSize: 16)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: alarm['isEnabled'],
                          activeColor: Colors.teal,
                          onChanged: (bool value) {
                            setState(() {
                              alarm['isEnabled'] = value;
                              alarm['isRinging'] = false;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _alarms.removeAt(index);
                            });
                          },
                        ),
                      ],
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
