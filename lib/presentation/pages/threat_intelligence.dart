import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class ThreatIntelligencePage extends StatefulWidget {
  const ThreatIntelligencePage({super.key});

  @override
  State<ThreatIntelligencePage> createState() => _ThreatIntelligencePageState();
}

class _ThreatIntelligencePageState extends State<ThreatIntelligencePage> {
  late Timer _timer;
  final Random _random = Random();
  
  double _signaturesLoaded = 0;
  double _threatsDetected = 0;
  double _responseTime = 0;
  final List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 700), (_) {
      setState(() {
        _signaturesLoaded = (_signaturesLoaded + _random.nextInt(2) + 1) % 10000;
        _threatsDetected = (_threatsDetected + _random.nextInt(5) + 1).clamp(0, 100);
        _responseTime = (_responseTime + (_random.nextDouble() - 0.5) * 10).clamp(10, 500);
        
        final timestamp = DateTime.now().toString().split('.')[0];
        if (_logs.length > 12) _logs.removeAt(0);
        _logs.add('[$timestamp] Threat scan: ${_threatsDetected.toStringAsFixed(0)} detected');
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
        title: Text('Threat Intelligence', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
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
                      border: Border.all(color: Colors.cyan),
                    ),
                    child: Column(
                      children: [
                        const Text('Signatures', style: TextStyle(color: Colors.cyan)),
                        Text('${_signaturesLoaded.toStringAsFixed(0)}', 
                          style: const TextStyle(color: Colors.cyan, fontSize: 18, fontWeight: FontWeight.bold)),
                        LinearProgressIndicator(
                          value: _signaturesLoaded / 10000,
                          valueColor: const AlwaysStoppedAnimation(Colors.cyan),
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
                      border: Border.all(color: Colors.red),
                    ),
                    child: Column(
                      children: [
                        const Text('Threats Detected', style: TextStyle(color: Colors.red)),
                        Text('${_threatsDetected.toStringAsFixed(0)}', 
                          style: const TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
                        LinearProgressIndicator(
                          value: _threatsDetected / 100,
                          valueColor: const AlwaysStoppedAnimation(Colors.red),
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
              decoration: BoxDecoration(border: Border.all(color: Colors.orange)),
              width: double.infinity,
              child: Column(
                children: [
                  const Text('Response Time (ms)', style: TextStyle(color: Colors.orange)),
                  Text('${_responseTime.toStringAsFixed(0)}', 
                    style: const TextStyle(color: Colors.orange, fontSize: 18, fontWeight: FontWeight.bold)),
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
                  const Text('Intelligence Log', style: TextStyle(color: Colors.green)),
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











