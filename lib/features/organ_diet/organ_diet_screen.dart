import 'package:flutter/material.dart';

class OrganDietModel {
  final String organName;
  final String icon;
  final Color themeColor;
  final List<String> foodsToEat;
  final List<String> foodsToAvoid;

  OrganDietModel({
    required this.organName,
    required this.icon,
    required this.themeColor,
    required this.foodsToEat,
    required this.foodsToAvoid,
  });
}

class OrganDietScreen extends StatelessWidget {
  OrganDietScreen({super.key});

  final List<OrganDietModel> organDietList = [
    OrganDietModel(
      organName: 'Eye (Aankh)',
      icon: '👁️',
      themeColor: Colors.blue,
      foodsToEat: ['Carrots (Gajar)', 'Spinach (Palak)', 'Eggs', 'Almonds'],
      foodsToAvoid: ['Excessive Sugar', 'Deep-fried Foods'],
    ),
    OrganDietModel(
      organName: 'Brain (Dimag)',
      icon: '🧠',
      themeColor: Colors.purple,
      foodsToEat: ['Walnuts (Akhrot)', 'Dark Chocolate', 'Turmeric (Haldi)'],
      foodsToAvoid: ['Alcohol', 'Sugary Drinks'],
    ),
    OrganDietModel(
      organName: 'Heart (Dil)',
      icon: '❤️',
      themeColor: Colors.red,
      foodsToEat: ['Oats', 'Garlic (Lahsun)', 'Olive Oil', 'Green Veggies'],
      foodsToAvoid: ['High Salt', 'Red Meat'],
    ),
    OrganDietModel(
      organName: 'Lungs (Fefde)',
      icon: '🫁',
      themeColor: Colors.teal,
      foodsToEat: ['Apples', 'Ginger (Adrak)', 'Tomatoes', 'Green Tea'],
      foodsToAvoid: ['Cold Water/Drinks', 'Excess Dairy'],
    ),
    OrganDietModel(
      organName: 'Liver (Jigar)',
      icon: '🪵',
      themeColor: Colors.amber.shade800,
      foodsToEat: ['Coffee', 'Beetroot Juice', 'Garlic', 'Broccoli'],
      foodsToAvoid: ['Alcohol', 'Refined Flour (Maida)'],
    ),
    OrganDietModel(
      organName: 'Kidney (Gurda)',
      icon: '🫘',
      themeColor: Colors.brown,
      foodsToEat: ['Watermelon', 'Cranberries', 'Cabbage', 'Water'],
      foodsToAvoid: ['High Sodium Foods', 'Carbonated Drinks'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Organ Health & Diet Guide'), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: organDietList.length,
        itemBuilder: (context, index) {
          final organ = organDietList[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: organ.themeColor.withOpacity(0.15),
                radius: 25,
                child: Text(organ.icon, style: const TextStyle(fontSize: 24)),
              ),
              title: Text(organ.organName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              subtitle: const Text('Tap to view recommended diet'),
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDietSection('Kya Khayein', organ.foodsToEat, Colors.green, Icons.check_circle),
                      const SizedBox(height: 15),
                      _buildDietSection('Kisse Bachein', organ.foodsToAvoid, Colors.red, Icons.cancel),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDietSection(String title, List<String> items, Color color, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          children: items.map((item) => Chip(label: Text(item), backgroundColor: color.withOpacity(0.08))).toList(),
        ),
      ],
    );
  }
}
