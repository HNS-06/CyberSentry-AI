import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ThreatRadar extends StatefulWidget {
  const ThreatRadar({super.key});

  @override
  State<ThreatRadar> createState() => _ThreatRadarState();
}

class _ThreatRadarState extends State<ThreatRadar> {
  final Random _rnd = Random();
  late Timer _timer;
  List<Offset> blips = [];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 700), (_) {
      setState(() {
        blips.add(Offset(_rnd.nextDouble(), _rnd.nextDouble()));
        if (blips.length > 12) blips.removeAt(0);
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
    return LayoutBuilder(builder: (context, constraints) {
      return CustomPaint(
        size: constraints.biggest,
        painter: _RadarPainter(List.of(blips)),
      );
    });
  }
}

class _RadarPainter extends CustomPainter {
  final List<Offset> blips;
  _RadarPainter(this.blips);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = min(size.width, size.height) * 0.45;
    final paint = Paint()..style = PaintingStyle.stroke..color = Colors.green.withOpacity(0.6);
    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(center, radius * (i / 4), paint);
    }

    final blipPaint = Paint()..color = Colors.redAccent.withOpacity(0.9);
    for (var b in blips) {
      final pos = Offset((b.dx - 0.5) * radius * 2, (b.dy - 0.5) * radius * 2) + center;
      canvas.drawCircle(pos, 6, blipPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) => true;
}
