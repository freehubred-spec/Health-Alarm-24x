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
      title: 'Health & Talking Alarm 24x',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const MainDashboard(),
    );
  }
}

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  final FlutterTts flutterTts = FlutterTts();
  int _selectedIndex = 0;

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("hi-IN");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildAlarmTab(),
      _buildHealthCalculatorsTab(),
      _buildYogaDietTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health & Talking Alarm 24x'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.teal,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: 'Talking Alarm'),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Calculators'),
          BottomNavigationBarItem(icon: Icon(Icons.self_improvement), label: 'Yoga & Diet'),
        ],
      ),
    );
  }

  Widget _buildAlarmTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.record_voice_over, size: 80, color: Colors.teal),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            onPressed: () => _speak("Namaste! Yeh aapka swasthya alarm hai. Paani peene ka samay ho gaya hai."),
            icon: const Icon(Icons.volume_up),
            label: const Text('Test Talking Alarm (Hindi)'),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthCalculatorsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Card(child: ListTile(leading: Icon(Icons.fitness_center, color: Colors.teal), title: Text('BMI Calculator'), subtitle: Text('Calculate Body Mass Index'))),
        Card(child: ListTile(leading: Icon(Icons.water_drop, color: Colors.teal), title: Text('Water Intake Calculator'), subtitle: Text('Daily hydration requirements'))),
        Card(child: ListTile(leading: Icon(Icons.restaurant, color: Colors.teal), title: Text('Calorie & Protein Counter'), subtitle: Text('Nutrition planning'))),
      ],
    );
  }

  Widget _buildYogaDietTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Card(child: ListTile(leading: Icon(Icons.no_food, color: Colors.teal), title: Text('Organ Specific Diets'), subtitle: Text('Liver, Kidney, Heart Healthy Foods'))),
        Card(child: ListTile(leading: Icon(Icons.self_improvement, color: Colors.teal), title: Text('Daily Yoga Guides'), subtitle: Text('Step-by-step posture & breathing routines'))),
      ],
    );
  }
}
