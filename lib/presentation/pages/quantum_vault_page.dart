import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class QuantumVaultPage extends StatefulWidget {
  const QuantumVaultPage({super.key});

  @override
  State<QuantumVaultPage> createState() => _QuantumVaultPageState();
}

class _QuantumVaultPageState extends State<QuantumVaultPage> {
  late Timer _timer;
  final Random _random = Random();
  
  double _keysGenerated = 0;
  double _dataEncrypted = 0;
  double _operationsPerSec = 0;
  final List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 600), (_) {
      setState(() {
        _keysGenerated = (_keysGenerated + _random.nextInt(3) + 1) % 1000;
        _dataEncrypted = (_dataEncrypted + _random.nextInt(150) + 50).clamp(0, 100);
        _operationsPerSec = (_operationsPerSec + (_random.nextDouble() - 0.5) * 100).clamp(1000, 9999);
        
        final timestamp = DateTime.now().toString().split('.')[0];
        if (_logs.length > 12) _logs.removeAt(0);
        _logs.add('[$timestamp] Quantum key: ${_keysGenerated.toStringAsFixed(0)}');
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
        title: Text('Quantum Vault', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
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
                        const Text('Keys Generated', style: TextStyle(color: Color(0xFF00FF9D))),
                        Text('${_keysGenerated.toStringAsFixed(0)}', 
                          style: const TextStyle(color: Color(0xFF00FF9D), fontSize: 18, fontWeight: FontWeight.bold)),
                        LinearProgressIndicator(
                          value: _keysGenerated / 1000,
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
                      border: Border.all(color: Colors.purple),
                    ),
                    child: Column(
                      children: [
                        const Text('Encryption Rate', style: TextStyle(color: Colors.purple)),
                        Text('${_dataEncrypted.toStringAsFixed(1)}%', 
                          style: const TextStyle(color: Colors.purple, fontSize: 18, fontWeight: FontWeight.bold)),
                        LinearProgressIndicator(
                          value: _dataEncrypted / 100,
                          valueColor: const AlwaysStoppedAnimation(Colors.purple),
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
                  const Text('Operations/sec', style: TextStyle(color: Colors.purple)),
                  Text('${_operationsPerSec.toStringAsFixed(0)}', 
                    style: const TextStyle(color: Colors.purple, fontSize: 18, fontWeight: FontWeight.bold)),
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
                  const Text('Vault Log', style: TextStyle(color: Colors.green)),
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












