import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class TrustClusterPage extends StatefulWidget {
  const TrustClusterPage({super.key});

  @override
  State<TrustClusterPage> createState() => _TrustClusterPageState();
}

class _TrustClusterPageState extends State<TrustClusterPage> {
  late Timer _timer;
  final Random _random = Random();
  
  double _clustersFormed = 0;
  double _devicesConnected = 0;
  double _trustScore = 0;
  final List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 900), (_) {
      setState(() {
        _clustersFormed = (_clustersFormed + _random.nextInt(2) + 1).clamp(5, 50);
        _devicesConnected = (_devicesConnected + _random.nextInt(10) + 2).clamp(10, 500);
        _trustScore = (_trustScore + (_random.nextDouble() - 0.5) * 5).clamp(60, 98);
        
        final timestamp = DateTime.now().toString().split('.')[0];
        if (_logs.length > 12) _logs.removeAt(0);
        _logs.add('[$timestamp] Cluster formed: ${_clustersFormed.toStringAsFixed(0)}');
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
        title: Text('Trust Cluster', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
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
                        const Text('Clusters', style: TextStyle(color: Colors.cyan)),
                        Text('${_clustersFormed.toStringAsFixed(0)}', 
                          style: const TextStyle(color: Colors.cyan, fontSize: 18, fontWeight: FontWeight.bold)),
                        LinearProgressIndicator(
                          value: (_clustersFormed / 50).clamp(0, 1),
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
                      border: Border.all(color: Colors.cyan),
                    ),
                    child: Column(
                      children: [
                        const Text('Devices Connected', style: TextStyle(color: Colors.cyan)),
                        Text('${_devicesConnected.toStringAsFixed(0)}', 
                          style: const TextStyle(color: Colors.cyan, fontSize: 18, fontWeight: FontWeight.bold)),
                        LinearProgressIndicator(
                          value: (_devicesConnected / 500).clamp(0, 1),
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
              decoration: BoxDecoration(border: Border.all(color: Colors.green)),
              width: double.infinity,
              child: Column(
                children: [
                  const Text('Trust Score', style: TextStyle(color: Colors.green)),
                  Text('${_trustScore.toStringAsFixed(1)}%', 
                    style: const TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold)),
                  LinearProgressIndicator(
                    value: _trustScore / 100,
                    valueColor: const AlwaysStoppedAnimation(Colors.green),
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
                  const Text('Cluster Log', style: TextStyle(color: Colors.green)),
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












