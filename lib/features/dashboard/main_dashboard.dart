import 'package:flutter/material.dart';
import '../alarm/alarm_screen.dart';
import '../calculators/health_calculators_screen.dart';
import '../yoga/yoga_screen.dart';
import '../organ_diet/organ_diet_screen.dart';
import '../../core/services/auth_service.dart';
import '../subscription/paywall_screen.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;
  int _remainingTrialDays = 15;

  final List<Widget> _screens = [
    const AlarmListScreen(),
    const HealthCalculatorsScreen(),
    YogaScreen(),
    OrganDietScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _checkTrial();
  }

  void _checkTrial() async {
    var status = await AuthService().checkAccessStatus();
    if (status['reason'] == 'FREE_TRIAL') {
      setState(() => _remainingTrialDays = status['remainingDays'] ?? 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health & Talking Alarm')),
      body: Column(
        children: [
          Container(
            color: Colors.amber.shade100,
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Trial: $_remainingTrialDays Days Left', style: const TextStyle(fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PaywallScreen())),
                  child: const Text('Subscribe ₹49'),
                )
              ],
            ),
          ),
          Expanded(child: IndexedStack(index: _currentIndex, children: _screens)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: 'Alarms'),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Calculators'),
          BottomNavigationBarItem(icon: Icon(Icons.self_improvement), label: 'Yoga'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Diet'),
        ],
      ),
    );
  }
}

class AlarmListScreen extends StatelessWidget {
  const AlarmListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Talking Alarm Home Screen'));
  }
}
