import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class MatrixRain extends StatefulWidget {
  const MatrixRain({super.key});

  @override
  State<MatrixRain> createState() => _MatrixRainState();
}

class _MatrixRainState extends State<MatrixRain> with SingleTickerProviderStateMixin {
  final Random _rnd = Random();
  late Timer _timer;
  List<double> drops = [];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 80), (_) {
      setState(() {
        if (drops.length < 80) drops.add(_rnd.nextDouble());
        for (var i = 0; i < drops.length; i++) {
          drops[i] += 0.02 + _rnd.nextDouble() * 0.05;
        }
        drops.removeWhere((d) => d > 1.6);
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
    return CustomPaint(
      painter: _MatrixPainter(drops),
      size: Size.infinite,
    );
  }
}

class _MatrixPainter extends CustomPainter {
  final List<double> drops;
  final Random _rnd = Random();

  _MatrixPainter(this.drops);

  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = TextStyle(color: Colors.greenAccent.shade100, fontSize: 12);
    final tp = TextPainter(textDirection: TextDirection.ltr);
    final columns = (size.width / 12).floor();

    for (int i = 0; i < drops.length; i++) {
      final x = (i % max(1, columns)) * 12.0;
      final y = drops[i] * size.height;
      tp.text = TextSpan(text: String.fromCharCode(33 + _rnd.nextInt(94)), style: textStyle);
      tp.layout();
      tp.paint(canvas, Offset(x, y % size.height));
    }
  }

  @override
  bool shouldRepaint(covariant _MatrixPainter oldDelegate) => true;
}
