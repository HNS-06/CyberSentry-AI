import 'dart:async';

import 'package:flutter/material.dart';

class HackerTerminal extends StatefulWidget {
  const HackerTerminal({super.key});

  @override
  State<HackerTerminal> createState() => _HackerTerminalState();
}

class _HackerTerminalState extends State<HackerTerminal> {
  final List<String> lines = [];
  late Timer _timer;
  int _step = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() {
        lines.add('> ${_messages[_step % _messages.length]}');
        _step++;
        if (lines.length > 10) lines.removeAt(0);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  static const _messages = [
    'Scanning processes...',
    'Analyzing behavior...',
    'Updating firewall rules...',
    'Deploying honeypot...',
    'Calibrating biometrics...',
    'Encrypting quantum vault...',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.greenAccent),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: ListView.builder(
          itemCount: lines.length,
          reverse: false,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return Text(lines[index], style: const TextStyle(color: Colors.green));
          },
        ),
      ),
    );
  }
}

