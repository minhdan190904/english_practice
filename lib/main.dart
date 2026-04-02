import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Azure Speech Test',
      theme: ThemeData(useMaterial3: true),
      home: const SpeechTestPage(),
    );
  }
}

class SpeechTestPage extends StatefulWidget {
  const SpeechTestPage({super.key});

  @override
  State<SpeechTestPage> createState() => _SpeechTestPageState();
}

class _SpeechTestPageState extends State<SpeechTestPage> {
  static const azureRegion = 'southeastasia';
  static const azureKey = 'PASTE_YOUR_AZURE_SPEECH_KEY_HERE';

  final _recorder = AudioRecorder();

  bool _isRecording = false;

  final _languageCtrl = TextEditingController(text: 'en-US');
  final _referenceTextCtrl = TextEditingController(text: 'Good morning.');
  final _statusCtrl = TextEditingController(text: '');

  String _recognizedText = '';
  Map<String, dynamic>? _scores;
  Map<String, dynamic>? _raw;

  String? _currentPath;

  @override
  void dispose() {
    _recorder.dispose();
    _languageCtrl.dispose();
    _referenceTextCtrl.dispose();
    _statusCtrl.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    final hasPerm = await _recorder.hasPermission();
    if (!hasPerm) {
      setState(() {
        _statusCtrl.text = 'No microphone permission-test';
      });
      return;
    }

    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/azure_speech_test.wav';

    await _recorder.start(
      RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 16000,
        numChannels: 1,
      ),
      path: path,
    );

    setState(() {
      _isRecording = true;
      _currentPath = path;
      _recognizedText = '';
      _scores = null;
      _raw = null;
      _statusCtrl.text = 'Recording... (keep it under 30s if using pronunciation)';
    });
  }

  Future<void> _stopAndEvaluate() async {
    final stoppedPath = await _recorder.stop();
    final path = stoppedPath ?? _currentPath;

    setState(() {
      _isRecording = false;
      _statusCtrl.text = 'Uploading audio to Azure...';
    });

    if (path == null || !File(path).existsSync()) {
      setState(() {
        _statusCtrl.text = 'Audio file not found';
      });
      return;
    }

    final audioBytes = await File(path).readAsBytes();
    final language = _languageCtrl.text.trim().isEmpty ? 'en-US' : _languageCtrl.text.trim();
    final referenceText = _referenceTextCtrl.text.trim();

    final uri = Uri.parse(
      'https://$azureRegion.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1'
          '?language=$language&format=detailed',
    );

    final headers = <String, String>{
      'Ocp-Apim-Subscription-Key': azureKey,
      'Content-Type': 'audio/wav; codecs=audio/pcm; samplerate=16000',
      'Accept': 'application/json',
    };

    if (referenceText.isNotEmpty) {
      final pronParams = jsonEncode({
        'ReferenceText': referenceText,
        'GradingSystem': 'HundredMark',
        'Granularity': 'Word',
        'Dimension': 'Comprehensive',
        'EnableProsodyAssessment': 'True',
        'EnableMiscue': 'True',
      });
      headers['Pronunciation-Assessment'] = base64Encode(utf8.encode(pronParams));
    }

    http.Response resp;
    try {
      resp = await http.post(uri, headers: headers, body: audioBytes);
    } catch (e) {
      setState(() {
        _statusCtrl.text = 'HTTP error: $e';
      });
      return;
    }

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      setState(() {
        _statusCtrl.text = 'Azure error ${resp.statusCode}: ${resp.body}';
      });
      return;
    }

    Map<String, dynamic> data;
    try {
      data = jsonDecode(resp.body) as Map<String, dynamic>;
    } catch (_) {
      setState(() {
        _statusCtrl.text = 'Invalid JSON response';
      });
      return;
    }

    final recognized = _extractRecognizedText(data);
    final scores = _extractPronScores(data);

    setState(() {
      _raw = data;
      _recognizedText = recognized ?? '';
      _scores = scores;
      _statusCtrl.text = 'Done';
    });
  }

  String? _extractRecognizedText(Map<String, dynamic> data) {
    if (data['DisplayText'] is String) return data['DisplayText'] as String;

    final nbest = data['NBest'];
    if (nbest is List && nbest.isNotEmpty) {
      final first = nbest.first;
      if (first is Map<String, dynamic>) {
        if (first['Display'] is String) return first['Display'] as String;
        if (first['Lexical'] is String) return first['Lexical'] as String;
      }
    }
    return null;
  }

  Map<String, dynamic>? _extractPronScores(Map<String, dynamic> data) {
    final nbest = data['NBest'];
    if (nbest is! List || nbest.isEmpty) return null;

    final first = nbest.first;
    if (first is! Map<String, dynamic>) return null;

    final pa = first['PronunciationAssessment'];
    if (pa is! Map<String, dynamic>) return null;

    final out = <String, dynamic>{};
    for (final k in [
      'AccuracyScore',
      'FluencyScore',
      'CompletenessScore',
      'PronScore',
      'ProsodyScore',
    ]) {
      if (pa.containsKey(k)) out[k] = pa[k];
    }

    final words = first['Words'];
    if (words is List) {
      out['WordCount'] = words.length;
      final errors = words.where((w) {
        if (w is Map<String, dynamic>) {
          final wpa = w['PronunciationAssessment'];
          if (wpa is Map<String, dynamic> && wpa['ErrorType'] is String) {
            return (wpa['ErrorType'] as String) != 'None';
          }
        }
        return false;
      }).length;
      out['WordErrors'] = errors;
    }

    return out.isEmpty ? null : out;
  }

  @override
  Widget build(BuildContext context) {
    final scores = _scores;

    return Scaffold(
      appBar: AppBar(title: const Text('Azure Speech Test')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _languageCtrl,
              decoration: const InputDecoration(
                labelText: 'Language (e.g. en-US)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _referenceTextCtrl,
              decoration: const InputDecoration(
                labelText: 'Reference text (leave empty to do normal STT)',
                border: OutlineInputBorder(),
              ),
              minLines: 2,
              maxLines: 4,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: _isRecording ? null : _startRecording,
                    child: const Text('Start recording'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _isRecording ? _stopAndEvaluate : null,
                    child: const Text('Stop & evaluate'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _statusCtrl,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Recognized text:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            SelectableText(_recognizedText.isEmpty ? '-' : _recognizedText),
            const SizedBox(height: 16),
            const Text('Scores:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            if (scores == null)
              const Text('-')
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: scores.entries
                    .map((e) => Text('${e.key}: ${e.value}'))
                    .toList(),
              ),
            const SizedBox(height: 16),
            const Text('Raw JSON:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            SelectableText(_raw == null ? '-' : const JsonEncoder.withIndent('  ').convert(_raw)),
          ],
        ),
      ),
    );
  }
}