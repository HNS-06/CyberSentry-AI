import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class CyberGardenPage extends StatefulWidget {
  const CyberGardenPage({super.key});

  @override
  State<CyberGardenPage> createState() => _CyberGardenPageState();
}

class _CyberGardenPageState extends State<CyberGardenPage> {
  late Timer _timer;
  final Random _random = Random();
  
  double _immuneCellsActive = 0;
  double _virusesNeutralized = 0;
  double _antibodiesGenerated = 0;
  final List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() {
        _immuneCellsActive = (_immuneCellsActive + (_random.nextDouble() - 0.5) * 20).clamp(20, 100);
        _virusesNeutralized = (_virusesNeutralized + _random.nextInt(8) + 2).clamp(0, 1000);
        _antibodiesGenerated = (_antibodiesGenerated + _random.nextInt(15) + 5).clamp(0, 500);
        
        final timestamp = DateTime.now().toString().split('.')[0];
        if (_logs.length > 12) _logs.removeAt(0);
        _logs.add('[$timestamp] Garden health: ${_immuneCellsActive.toStringAsFixed(0)}%');
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
        title: Text('Cyber Garden', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
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
                      border: Border.all(color: Colors.lightGreen),
                    ),
                    child: Column(
                      children: [
                        const Text('Immune Cells', style: TextStyle(color: Colors.lightGreen)),
                        Text('${_immuneCellsActive.toStringAsFixed(0)}%', 
                          style: const TextStyle(color: Colors.lightGreen, fontSize: 18, fontWeight: FontWeight.bold)),
                        LinearProgressIndicator(
                          value: _immuneCellsActive / 100,
                          valueColor: const AlwaysStoppedAnimation(Colors.lightGreen),
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
                        const Text('Viruses Neutralized', style: TextStyle(color: Colors.amber)),
                        Text('${_virusesNeutralized.toStringAsFixed(0)}', 
                          style: const TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)),
                        LinearProgressIndicator(
                          value: (_virusesNeutralized / 1000).clamp(0, 1),
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
              decoration: BoxDecoration(border: Border.all(color: Colors.pink)),
              width: double.infinity,
              child: Column(
                children: [
                  const Text('Antibodies Generated', style: TextStyle(color: Colors.pink)),
                  Text('${_antibodiesGenerated.toStringAsFixed(0)}', 
                    style: const TextStyle(color: Colors.pink, fontSize: 18, fontWeight: FontWeight.bold)),
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
                  const Text('Garden Log', style: TextStyle(color: Colors.green)),
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












