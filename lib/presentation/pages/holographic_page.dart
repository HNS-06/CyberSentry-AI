import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class HolographicPage extends StatefulWidget {
  const HolographicPage({super.key});

  @override
  State<HolographicPage> createState() => _HolographicPageState();
}

class _HolographicPageState extends State<HolographicPage> {
  late Timer _timer;
  final Random _random = Random();
  
  double _fps = 0;
  double _objectsRendered = 0;
  double _updateLatency = 0;
  final List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() {
        _fps = (_fps + (_random.nextDouble() - 0.5) * 15).clamp(30, 144);
        _objectsRendered = (_objectsRendered + _random.nextInt(100) + 50).clamp(500, 5000);
        _updateLatency = (_updateLatency + (_random.nextDouble() - 0.5) * 3).clamp(5, 50);
        
        final timestamp = DateTime.now().toString().split('.')[0];
        if (_logs.length > 12) _logs.removeAt(0);
        _logs.add('[$timestamp] Rendering: ${_fps.toStringAsFixed(0)} FPS');
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
        title: Text('Holographic', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
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
                        const Text('FPS', style: TextStyle(color: Colors.cyan)),
                        Text('${_fps.toStringAsFixed(0)}', 
                          style: const TextStyle(color: Colors.cyan, fontSize: 18, fontWeight: FontWeight.bold)),
                        LinearProgressIndicator(
                          value: _fps / 144,
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
                      border: Border.all(color: Colors.lightGreen),
                    ),
                    child: Column(
                      children: [
                        const Text('Objects', style: TextStyle(color: Colors.lightGreen)),
                        Text('${_objectsRendered.toStringAsFixed(0)}', 
                          style: const TextStyle(color: Colors.lightGreen, fontSize: 18, fontWeight: FontWeight.bold)),
                        LinearProgressIndicator(
                          value: (_objectsRendered / 5000).clamp(0, 1),
                          valueColor: const AlwaysStoppedAnimation(Colors.lightGreen),
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
                  const Text('Latency (ms)', style: TextStyle(color: Colors.orange)),
                  Text('${_updateLatency.toStringAsFixed(2)}', 
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
                  const Text('Render Log', style: TextStyle(color: Colors.green)),
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












