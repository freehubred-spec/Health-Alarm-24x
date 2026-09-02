import 'package:flutter/material.dart';

class HealthCalculatorsScreen extends StatefulWidget {
  const HealthCalculatorsScreen({super.key});

  @override
  State<HealthCalculatorsScreen> createState() => _HealthCalculatorsScreenState();
}

class _HealthCalculatorsScreenState extends State<HealthCalculatorsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  double? _bmiResult;
  double? _waterResult;
  double? _caloriesResult;
  double? _proteinResult;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  void _calculateBMI() {
    double? w = double.tryParse(_weightController.text);
    double? h = double.tryParse(_heightController.text);
    if (w != null && h != null && h > 0) {
      setState(() => _bmiResult = w / ((h / 100) * (h / 100)));
    }
  }

  void _calculateWater() {
    double? w = double.tryParse(_weightController.text);
    if (w != null) setState(() => _waterResult = w * 0.033);
  }

  void _calculateCalories() {
    double? w = double.tryParse(_weightController.text);
    double? h = double.tryParse(_heightController.text);
    int? a = int.tryParse(_ageController.text);
    if (w != null && h != null && a != null) {
      setState(() => _caloriesResult = ((10 * w) + (6.25 * h) - (5 * a) + 5) * 1.55);
    }
  }

  void _calculateProtein() {
    double? w = double.tryParse(_weightController.text);
    if (w != null) setState(() => _proteinResult = w * 1.2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Calculators'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [Tab(text: 'BMI'), Tab(text: 'Water'), Tab(text: 'Calories'), Tab(text: 'Protein')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCalcTab('Calculate BMI', _calculateBMI, _bmiResult, 'Score'),
          _buildCalcTab('Calculate Water', _calculateWater, _waterResult, 'Liters/Day'),
          _buildCalcTab('Calculate Calories', _calculateCalories, _caloriesResult, 'kcal/Day'),
          _buildCalcTab('Calculate Protein', _calculateProtein, _proteinResult, 'Grams/Day'),
        ],
      ),
    );
  }

  Widget _buildCalcTab(String btnText, VoidCallback onCalc, double? result, String unit) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(controller: _weightController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Weight (kg)', border: OutlineInputBorder())),
          const SizedBox(height: 10),
          TextField(controller: _heightController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Height (cm)', border: OutlineInputBorder())),
          const SizedBox(height: 10),
          TextField(controller: _ageController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Age', border: OutlineInputBorder())),
          const SizedBox(height: 15),
          ElevatedButton(onPressed: onCalc, child: Text(btnText)),
          if (result != null) ...[
            const SizedBox(height: 20),
            Text('Result: ${result.toStringAsFixed(1)} $unit', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ]
        ],
      ),
    );
  }
}
