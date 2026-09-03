import 'package:flutter/material.dart';

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
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildAlarmTab(),
      _buildCalculatorsTab(),
      _buildYogaDietTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health & Alarm 24x'),
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
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: 'Alarm'),
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
          const Icon(Icons.notifications_active, size: 80, color: Colors.teal),
          const SizedBox(height: 20),
          const Text(
            'Health Alarm 24x',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text('Paani peene aur workout ka reminder set karein.'),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Alarm reminder set ho gaya!')),
              );
            },
            icon: const Icon(Icons.check_circle),
            label: const Text('Set Health Reminder'),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatorsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Card(
          child: ListTile(
            leading: Icon(Icons.fitness_center, color: Colors.teal),
            title: Text('BMI Calculator'),
            subtitle: Text('Body Mass Index check karein'),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.water_drop, color: Colors.teal),
            title: Text('Water Intake Calculator'),
            subtitle: Text('Roz kitna paani peena chahiye'),
          ),
        ),
      ],
    );
  }

  Widget _buildYogaDietTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Card(
          child: ListTile(
            leading: Icon(Icons.no_food, color: Colors.teal),
            title: Text('Diet Routine'),
            subtitle: Text('Healthy food chart for daily fitness'),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.self_improvement, color: Colors.teal),
            title: Text('Yoga & Exercise'),
            subtitle: Text('Daily workout plans'),
          ),
        ),
      ],
    );
  }
}
