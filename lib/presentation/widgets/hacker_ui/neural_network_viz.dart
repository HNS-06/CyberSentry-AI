import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class NeuralNetworkViz extends StatefulWidget {
  const NeuralNetworkViz({super.key});

  @override
  State<NeuralNetworkViz> createState() => _NeuralNetworkVizState();
}

class _NeuralNetworkVizState extends State<NeuralNetworkViz> {
  late Timer _timer;
  final Random _rnd = Random();
  List<double> activations = List.filled(12, 0.0);

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      setState(() {
        for (var i = 0; i < activations.length; i++) {
          activations[i] = (_rnd.nextDouble());
        }
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: activations
          .map((a) => Container(
                width: 16,
                height: 120 * a + 8,
                decoration: BoxDecoration(
                  color: Colors.cyanAccent.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(4),
                ),
              ))
          .toList(),
    );
  }
}
