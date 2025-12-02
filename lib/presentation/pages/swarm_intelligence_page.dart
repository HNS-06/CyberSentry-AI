import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class SwarmIntelligencePage extends StatefulWidget {
  const SwarmIntelligencePage({super.key});

  @override
  State<SwarmIntelligencePage> createState() => _SwarmIntelligencePageState();
}

class _SwarmIntelligencePageState extends State<SwarmIntelligencePage> {
  late Timer _timer;
  final Random _random = Random();
  
  double _agentsActive = 0;
  double _collectiveIntelligence = 0;
  double _coordinationRate = 0;
  final List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 700), (_) {
      setState(() {
        _agentsActive = (_agentsActive + (_random.nextDouble() - 0.5) * 20).clamp(50, 300);
        _collectiveIntelligence = (_collectiveIntelligence + (_random.nextDouble() - 0.5) * 10).clamp(40, 100);
        _coordinationRate = (_coordinationRate + (_random.nextDouble() - 0.5) * 8).clamp(60, 98);
        
        final timestamp = DateTime.now().toString().split('.')[0];
        if (_logs.length > 12) _logs.removeAt(0);
        _logs.add('[$timestamp] Agents: ${_agentsActive.toStringAsFixed(0)}');
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
        title: Text('Swarm Intelligence', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
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
                        const Text('Agents Active', style: TextStyle(color: Color(0xFF00FF9D))),
                        Text('${_agentsActive.toStringAsFixed(0)}', 
                          style: const TextStyle(color: Color(0xFF00FF9D), fontSize: 18, fontWeight: FontWeight.bold)),
                        LinearProgressIndicator(
                          value: _agentsActive / 300,
                          valueColor: const AlwaysStoppedAnimation(Color(0xFF00FF9D)),
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
                      border: Border.all(color: Colors.amber),
                    ),
                    child: Column(
                      children: [
                        const Text('Collective IQ', style: TextStyle(color: Colors.amber)),
                        Text('${_collectiveIntelligence.toStringAsFixed(0)}', 
                          style: const TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)),
                        LinearProgressIndicator(
                          value: _collectiveIntelligence / 100,
                          valueColor: const AlwaysStoppedAnimation(Colors.amber),
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
              decoration: BoxDecoration(border: Border.all(color: Colors.cyan)),
              width: double.infinity,
              child: Column(
                children: [
                  const Text('Coordination Rate (%)', style: TextStyle(color: Colors.cyan)),
                  Text('${_coordinationRate.toStringAsFixed(1)}%', 
                    style: const TextStyle(color: Colors.cyan, fontSize: 18, fontWeight: FontWeight.bold)),
                  LinearProgressIndicator(
                    value: _coordinationRate / 100,
                    valueColor: const AlwaysStoppedAnimation(Colors.cyan),
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
                  const Text('Swarm Log', style: TextStyle(color: Colors.green)),
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












