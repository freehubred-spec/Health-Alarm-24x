import 'package:flutter/material.dart';

class YogaPoseModel {
  final String title;
  final String diseaseTag;
  final String benefits;
  final String imagePath;

  YogaPoseModel({
    required this.title,
    required this.diseaseTag,
    required this.benefits,
    required this.imagePath,
  });
}

class YogaScreen extends StatelessWidget {
  YogaScreen({super.key});

  final List<YogaPoseModel> yogaList = [
    YogaPoseModel(title: 'Bhujangasana', diseaseTag: 'Back Pain', benefits: 'Stretches spine flexibility.', imagePath: 'assets/yoga/bhujangasana.jpg'),
    YogaPoseModel(title: 'Mandukasana', diseaseTag: 'Diabetes', benefits: 'Stimulates pancreas.', imagePath: 'assets/yoga/mandukasana.jpg'),
    YogaPoseModel(title: 'Anulom Vilom', diseaseTag: 'High BP & Stress', benefits: 'Calms nervous system.', imagePath: 'assets/yoga/anulom_vilom.jpg'),
    YogaPoseModel(title: 'Sarvangasana', diseaseTag: 'Thyroid', benefits: 'Improves blood circulation.', imagePath: 'assets/yoga/sarvangasana.jpg'),
    YogaPoseModel(title: 'Pawanmuktasana', diseaseTag: 'Acidity', benefits: 'Releases trapped gas.', imagePath: 'assets/yoga/pawanmuktasana.jpg'),
    YogaPoseModel(title: 'Vrikshasana', diseaseTag: 'Focus', benefits: 'Enhances stability.', imagePath: 'assets/yoga/vrikshasana.jpg'),
    YogaPoseModel(title: 'Dhanurasana', diseaseTag: 'Obesity', benefits: 'Burns belly fat.', imagePath: 'assets/yoga/dhanurasana.jpg'),
    YogaPoseModel(title: 'Setu Bandhasana', diseaseTag: 'Asthma', benefits: 'Opens chest muscles.', imagePath: 'assets/yoga/setubandhasana.jpg'),
    YogaPoseModel(title: 'Shashankasana', diseaseTag: 'Anxiety', benefits: 'Relieves mental tiredness.', imagePath: 'assets/yoga/shashankasana.jpg'),
    YogaPoseModel(title: 'Trikonasana', diseaseTag: 'Sciatica', benefits: 'Stretches hips.', imagePath: 'assets/yoga/trikonasana.jpg'),
  ];

  void _openImageZoomModal(BuildContext context, String imagePath, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.black, iconTheme: const IconThemeData(color: Colors.white), title: Text(title, style: const TextStyle(color: Colors.white))),
          body: Center(
            child: InteractiveViewer(
              minScale: 0.8,
              maxScale: 4.0,
              child: Image.asset(imagePath, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.image_not_supported, color: Colors.white, size: 80)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Disease-wise Yoga Poses'), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: yogaList.length,
        itemBuilder: (context, index) {
          final yoga = yogaList[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(yoga.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Chip(label: Text(yoga.diseaseTag)),
                  Text('Benefits: ${yoga.benefits}'),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _openImageZoomModal(context, yoga.imagePath, yoga.title),
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: const Center(child: Text('Tap to View & Zoom Image')),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
