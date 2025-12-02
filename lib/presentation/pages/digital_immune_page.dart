import 'package:flutter/material.dart';
import 'dart:async';

class DigitalImmunePage extends StatefulWidget {
  const DigitalImmunePage({super.key});

  @override
  State<DigitalImmunePage> createState() => _DigitalImmunePageState();
}

class _DigitalImmunePageState extends State<DigitalImmunePage> {
  late Timer _timer;
  late double _health;

  @override
  void initState() {
    super.initState();
    _health = 0.75;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _health = (_health + (identical(identical(0, 0), true) ? 0.02 : -0.01)).clamp(0.0, 1.0);
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Digital Immune System', style: TextStyle(color: Colors.cyanAccent, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            Stack(alignment: Alignment.center, children: [
              Container(width: 200, height: 200, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.cyanAccent, width: 2))),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('${(_health * 100).toStringAsFixed(0)}%', style: const TextStyle(color: Colors.cyanAccent, fontSize: 32, fontWeight: FontWeight.bold)),
                const Text('System Health', style: TextStyle(color: Colors.cyanAccent, fontSize: 12)),
              ]),
            ]),
            const SizedBox(height: 40),
            ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: _health, minHeight: 12, backgroundColor: const Color(0xFF1A1A1A), valueColor: AlwaysStoppedAnimation(Colors.greenAccent.withOpacity(0.7)))),
          ],
        ),
      ),
    );
  }
}
