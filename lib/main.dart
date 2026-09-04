import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
  final FlutterTts _flutterTts = FlutterTts();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initTts();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _checkAlarms();
    });
  }

  void _initTts() async {
    await _flutterTts.setLanguage("hi-IN");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _flutterTts.stop();
    super.dispose();
  }

  void _checkAlarms() {
    final now = TimeOfDay.now();
    for (var alarm in _alarms) {
      if (alarm['isEnabled'] == true &&
          alarm['time'].hour == now.hour &&
          alarm['time'].minute == now.minute &&
          alarm['isRinging'] == false) {
        setState(() {
          alarm['isRinging'] = true;
        });
        _triggerAlarm(alarm['title']);
      }
    }
  }

  void _triggerAlarm(String title) async {
    await _flutterTts.speak("Namaste! Dhyan dein, $title ka samay ho gaya hai.");

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.alarm_on, color: Colors.teal, size: 36),
              SizedBox(width: 10),
              Text('Alarm Ringing!'),
            ],
          ),
          content: Text(
            'Namaste! Time for: $title',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () async {
                await _flutterTts.stop();
                if (mounted) Navigator.pop(context);
              },
              child: const Text('STOP ALARM', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
