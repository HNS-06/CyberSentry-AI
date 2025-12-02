import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class NeuralFirewallPage extends StatefulWidget {
  const NeuralFirewallPage({super.key});

  @override
  State<NeuralFirewallPage> createState() => _NeuralFirewallPageState();
}

class _NeuralFirewallPageState extends State<NeuralFirewallPage> {
  late Timer _timer;
  final List<String> _logs = [];
  final List<String> _threats = ['Port scan detected', 'SQL injection attempt', 'DDoS pattern', 'Malware signature', 'Suspicious API call'];
  double _threatLevel = 0.0;
  int _threatsBlocked = 0;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 800), (_) {
      setState(() {
        _threatLevel = (_threatLevel + (_random.nextDouble() - 0.5) * 0.3).clamp(0.0, 1.0);
        _threatsBlocked += _random.nextInt(3);
        
        final threat = _threats[_random.nextInt(_threats.length)];
        _logs.add('[${DateTime.now().toString().split('.')[0]}] $threat: BLOCKED');
        if (_logs.length > 12) _logs.removeAt(0);
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
      body: Container(
        color: const Color(0xFF0A0A0A),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Neural Firewall - Real-time Monitoring', style: TextStyle(color: Colors.greenAccent, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            // Stats row
            Row(
              children: [
                _buildStat('Threat Level', '${(_threatLevel * 100).toStringAsFixed(1)}%', Colors.red),
                const SizedBox(width: 12),
                _buildStat('Threats Blocked', _threatsBlocked.toString(), Colors.green),
              ],
            ),
            const SizedBox(height: 12),
            
            // Threat level indicator
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: _threatLevel,
                minHeight: 12,
                backgroundColor: const Color(0xFF1A1A1A),
                valueColor: AlwaysStoppedAnimation(
                  _threatLevel > 0.7 ? Colors.red : _threatLevel > 0.4 ? Colors.yellow : Colors.green
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Activity log
            Expanded(
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.greenAccent), borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.all(12),
                child: ListView.builder(
                  itemCount: _logs.length,
                  itemBuilder: (context, idx) => Text(_logs[idx], style: const TextStyle(color: Colors.green, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(border: Border.all(color: color), borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: color, fontSize: 12)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
