import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  static final FlutterTts _flutterTts = FlutterTts();
  static bool _isSpeaking = false;
  static String _currentText = "";

  static Future<void> initTTS() async {
    await _flutterTts.setLanguage("hi-IN");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.9);
    await _flutterTts.setVolume(1.0);

    _flutterTts.setCompletionHandler(() {
      if (_isSpeaking) {
        _flutterTts.speak(_currentText);
      }
    });
  }

  static Future<void> speakLoop(String message) async {
    _isSpeaking = true;
    _currentText = message.isEmpty ? "Alarm time ho gaya hai!" : message;
    await _flutterTts.speak(_currentText);
  }

  static Future<void> stop() async {
    _isSpeaking = false;
    await _flutterTts.stop();
  }
}
