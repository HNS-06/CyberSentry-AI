import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class BehaviorBiometricsPage extends StatefulWidget {
  const BehaviorBiometricsPage({super.key});

  @override
  State<BehaviorBiometricsPage> createState() => _BehaviorBiometricsPageState();
}

class _BehaviorBiometricsPageState extends State<BehaviorBiometricsPage> {
  late Timer _timer;
  final Random _random = Random();
  
  double _anomaliesDetected = 0;
  double _biometricConfidence = 0;
  double _patternsRecognized = 0;
  final List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 750), (_) {
      setState(() {
        _anomaliesDetected = (_anomaliesDetected + _random.nextInt(4) + 1).clamp(0, 200);
        _biometricConfidence = (_biometricConfidence + (_random.nextDouble() - 0.5) * 8).clamp(75, 99);
        _patternsRecognized = (_patternsRecognized + _random.nextInt(6) + 2).clamp(10, 500);
        
        final timestamp = DateTime.now().toString().split('.')[0];
        if (_logs.length > 12) _logs.removeAt(0);
        _logs.add('[$timestamp] Biometric scan: ${_biometricConfidence.toStringAsFixed(1)}%');
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
        title: Text('Behavior & Biometrics', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
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
                      border: Border.all(color: Colors.orange),
                    ),
                    child: Column(
                      children: [
                        const Text('Anomalies', style: TextStyle(color: Colors.orange)),
                        Text('${_anomaliesDetected.toStringAsFixed(0)}', 
                          style: const TextStyle(color: Colors.orange, fontSize: 18, fontWeight: FontWeight.bold)),
                        LinearProgressIndicator(
                          value: (_anomaliesDetected / 200).clamp(0, 1),
                          valueColor: const AlwaysStoppedAnimation(Colors.orange),
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
                      border: Border.all(color: Colors.cyan),
                    ),
                    child: Column(
                      children: [
                        const Text('Patterns Recognized', style: TextStyle(color: Colors.cyan)),
                        Text('${_patternsRecognized.toStringAsFixed(0)}', 
                          style: const TextStyle(color: Colors.cyan, fontSize: 18, fontWeight: FontWeight.bold)),
                        LinearProgressIndicator(
                          value: _biometricConfidence / 100,
                          valueColor: const AlwaysStoppedAnimation(Colors.green),
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
              decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
              width: double.infinity,
              child: Column(
                children: [
                  const Text('Patterns Recognized', style: TextStyle(color: Colors.blue)),
                  Text('${_patternsRecognized.toStringAsFixed(0)}', 
                    style: const TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold)),
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
                  const Text('Biometric Log', style: TextStyle(color: Colors.green)),
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












