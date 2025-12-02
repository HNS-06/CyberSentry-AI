import 'package:flutter/material.dart';
import 'dart:async';

class ArSecurityPage extends StatefulWidget {
  const ArSecurityPage({super.key});

  @override
  State<ArSecurityPage> createState() => _ArSecurityPageState();
}


class _ArSecurityPageState extends State<ArSecurityPage> {
  late Timer _timer;
  late double _scale;
  late List<double> _positions;

  @override
  void initState() {
    super.initState();
    _scale = 1.0;
    _positions = [0.2, 0.4, 0.6, 0.8];
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      setState(() {
        _scale = _scale == 1.0 ? 1.1 : 1.0;
        _positions = _positions.map((p) => (p + 0.02) % 1.0).toList();
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
            const Text('AR Security Layer', style: TextStyle(color: Colors.pinkAccent, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.pinkAccent), borderRadius: BorderRadius.circular(8)),
                child: Stack(
                  children: [
                    for (var i = 0; i < _positions.length; i++)
                      Positioned(
                        left: _positions[i] * 250,
                        top: 50 + i * 60,
                        child: Transform.scale(
                          scale: _scale,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.pinkAccent),
                              boxShadow: [BoxShadow(color: Colors.pinkAccent.withOpacity(0.5), blurRadius: 10)],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
