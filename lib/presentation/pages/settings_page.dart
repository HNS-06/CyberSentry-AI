import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Timer _timer;
  final Random _random = Random();
  
  double _uptime = 0;
  double _requestsHandled = 0;
  double _memoryUsage = 0;
  final List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _uptime = (_uptime + 1) % 1000000;
        _requestsHandled = (_requestsHandled + _random.nextInt(50) + 10).clamp(0, 100000);
        _memoryUsage = (_memoryUsage + (_random.nextDouble() - 0.5) * 8).clamp(20, 95);
        
        final timestamp = DateTime.now().toString().split('.')[0];
        if (_logs.length > 10) _logs.removeAt(0);
        _logs.add('[$timestamp] System running');
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
        title: const Text('Settings', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
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
                      border: Border.all(color: const Color(0xFF00FF9D)),
                    ),
                    child: Column(
                      children: [
                        const Text('Uptime (sec)', style: TextStyle(color: Color(0xFF00FF9D))),
                        Text('${_uptime.toStringAsFixed(0)}', 
                          style: const TextStyle(color: Color(0xFF00FF9D), fontSize: 18, fontWeight: FontWeight.bold)),
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
                        const Text('Requests', style: TextStyle(color: Colors.cyan)),
                        Text('${_requestsHandled.toStringAsFixed(0)}', 
                          style: const TextStyle(color: Colors.cyan, fontSize: 18, fontWeight: FontWeight.bold)),
                        LinearProgressIndicator(
                          value: (_requestsHandled / 100000).clamp(0, 1),
                          valueColor: const AlwaysStoppedAnimation(Colors.cyan),
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
              decoration: BoxDecoration(border: Border.all(color: Colors.purple)),
              width: double.infinity,
              child: Column(
                children: [
                  const Text('Memory Usage (%)', style: TextStyle(color: Colors.purple)),
                  Text('${_memoryUsage.toStringAsFixed(1)}%', 
                    style: const TextStyle(color: Colors.purple, fontSize: 18, fontWeight: FontWeight.bold)),
                  LinearProgressIndicator(
                    value: _memoryUsage / 100,
                    valueColor: const AlwaysStoppedAnimation(Colors.purple),
                  ),
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
                  const Text('System Log', style: TextStyle(color: Colors.green)),
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

