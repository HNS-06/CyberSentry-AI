import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class DreamJournalPage extends StatefulWidget {
  const DreamJournalPage({super.key});

  @override
  State<DreamJournalPage> createState() => _DreamJournalPageState();
}

class _DreamJournalPageState extends State<DreamJournalPage> {
  late Timer _timer;
  final Random _random = Random();
  
  double _patternsRecognized = 0;
  double _confidenceLevel = 0;
  double _predictionsMade = 0;
  final List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 650), (_) {
      setState(() {
        _patternsRecognized = (_patternsRecognized + _random.nextInt(5) + 1).clamp(20, 1000);
        _confidenceLevel = (_confidenceLevel + (_random.nextDouble() - 0.5) * 6).clamp(55, 95);
        _predictionsMade = (_predictionsMade + _random.nextInt(3) + 1).clamp(0, 300);
        
        final timestamp = DateTime.now().toString().split('.')[0];
        if (_logs.length > 12) _logs.removeAt(0);
        _logs.add('[$timestamp] Pattern found: ${_patternsRecognized.toStringAsFixed(0)}');
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text('Dream Journal', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.purple),
                    ),
                    child: Column(
                      children: [
                        const Text('Patterns', style: TextStyle(color: Colors.purple)),
                        Text('${_patternsRecognized.toStringAsFixed(0)}', 
                          style: const TextStyle(color: Colors.purple, fontSize: 18, fontWeight: FontWeight.bold)),
                        LinearProgressIndicator(
                          value: (_patternsRecognized / 1000).clamp(0, 1),
                          valueColor: const AlwaysStoppedAnimation(Colors.purple),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.pink),
                    ),
                    child: Column(
                      children: [
                        const Text('Confidence', style: TextStyle(color: Colors.pink)),
                        Text('${_confidenceLevel.toStringAsFixed(1)}%', 
                          style: const TextStyle(color: Colors.pink, fontSize: 18, fontWeight: FontWeight.bold)),
                        LinearProgressIndicator(
                          value: _confidenceLevel / 100,
                          valueColor: const AlwaysStoppedAnimation(Colors.pink),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(border: Border.all(color: Colors.indigo)),
              width: double.infinity,
              child: Column(
                children: [
                  const Text('Predictions Made', style: TextStyle(color: Colors.indigo)),
                  Text('${_predictionsMade.toStringAsFixed(0)}', 
                    style: const TextStyle(color: Colors.indigo, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(border: Border.all(color: Colors.green)),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Dream Log', style: TextStyle(color: Colors.green)),
                  const SizedBox(height: 8),
                  ..._logs.map((log) => Text(log, style: const TextStyle(color: Colors.green, fontSize: 12))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}












