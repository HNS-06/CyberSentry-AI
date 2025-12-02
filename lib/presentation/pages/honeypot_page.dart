import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class HoneypotPage extends StatefulWidget {
  const HoneypotPage({super.key});

  @override
  State<HoneypotPage> createState() => _HoneypotPageState();
}

class _HoneypotPageState extends State<HoneypotPage> {
  late Timer _timer;
  final Random _random = Random();
  
  double _attackersTrapped = 0;
  double _successRate = 0;
  double _baitsDeployed = 0;
  final List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 800), (_) {
      setState(() {
        _attackersTrapped = (_attackersTrapped + _random.nextInt(3) + 1).clamp(0, 500);
        _successRate = (_successRate + (_random.nextDouble() - 0.5) * 5).clamp(65, 99);
        _baitsDeployed = (_baitsDeployed + _random.nextInt(2) + 1).clamp(10, 100);
        
        final timestamp = DateTime.now().toString().split('.')[0];
        if (_logs.length > 12) _logs.removeAt(0);
        _logs.add('[$timestamp] Trap triggered: ${_attackersTrapped.toStringAsFixed(0)} caught');
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
        title: Text('Honeypot', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
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
                        const Text('Baits Deployed', style: TextStyle(color: Colors.cyan)),
                        Text('${_baitsDeployed.toStringAsFixed(0)}', 
                          style: const TextStyle(color: Colors.cyan, fontSize: 18, fontWeight: FontWeight.bold)),
                        LinearProgressIndicator(
                          value: (_attackersTrapped / 500).clamp(0, 1),
                          valueColor: const AlwaysStoppedAnimation(Colors.red),
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
                      border: Border.all(color: Colors.green),
                    ),
                    child: Column(
                      children: [
                        const Text('Success Rate', style: TextStyle(color: Colors.green)),
                        Text('${_successRate.toStringAsFixed(1)}%', 
                          style: const TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold)),
                        LinearProgressIndicator(
                          value: _successRate / 100,
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
                  const Text('Baits Deployed', style: TextStyle(color: Colors.blue)),
                  Text('${_baitsDeployed.toStringAsFixed(0)}', 
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
                  const Text('Honeypot Log', style: TextStyle(color: Colors.green)),
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












