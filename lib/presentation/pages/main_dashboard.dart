import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  late Timer _updateTimer;
  late double _cpuUsage;
  late double _memoryUsage;
  late double _diskUsage;
  late double _gpuUsage;
  late List<String> _logs;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _cpuUsage = 45.0;
    _memoryUsage = 60.0;
    _diskUsage = 50.0;
    _gpuUsage = 30.0;
    _logs = [];
    
    _updateTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() {
        _cpuUsage = (_cpuUsage + (_random.nextDouble() - 0.5) * 15).clamp(5.0, 95.0);
        _memoryUsage = (_memoryUsage + (_random.nextDouble() - 0.5) * 10).clamp(10.0, 85.0);
        _diskUsage = 50.0 + (_random.nextDouble() - 0.5) * 5;
        _gpuUsage = (_gpuUsage + (_random.nextDouble() - 0.5) * 12).clamp(0.0, 100.0);
        
        _logs.add('[${DateTime.now().toString().split('.')[0]}] CPU: ${_cpuUsage.toStringAsFixed(1)}% | MEM: ${_memoryUsage.toStringAsFixed(1)}%');
        if (_logs.length > 8) _logs.removeAt(0);
      });
    });
  }

  @override
  void dispose() {
    _updateTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text('SYSTEM MONITORING', style: TextStyle(color: Colors.cyanAccent, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              
              // System metrics grid
              Row(
                children: [
                  _buildMetricCard('CPU', _cpuUsage, Colors.red),
                  const SizedBox(width: 12),
                  _buildMetricCard('MEMORY', _memoryUsage, Colors.cyan),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildMetricCard('DISK', _diskUsage, Colors.yellow),
                  const SizedBox(width: 12),
                  _buildMetricCard('GPU', _gpuUsage, Colors.green),
                ],
              ),
              const SizedBox(height: 16),
              
              // Matrix Rain animation
              Container(
                height: 150,
                decoration: BoxDecoration(border: Border.all(color: Colors.greenAccent)),
                child: Stack(
                  children: [
                    _buildMatrixRain(),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // System logs
              Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.greenAccent), borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('SYSTEM LOG', style: TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ..._logs.map((log) => Text(log, style: const TextStyle(color: Colors.green, fontSize: 11))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, double value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('${value.toStringAsFixed(1)}%', style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value / 100,
                minHeight: 6,
                backgroundColor: color.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatrixRain() {
    return CustomPaint(
      painter: _MatrixRainPainter(_cpuUsage / 100),
      size: Size.infinite,
    );
  }
}

class _MatrixRainPainter extends CustomPainter {
  final double intensity;
  _MatrixRainPainter(this.intensity);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.greenAccent.withOpacity(0.6);
    final random = Random(DateTime.now().millisecond);
    
    for (int i = 0; i < 20; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), 2 + (intensity * 3), paint);
    }
  }

  @override
  bool shouldRepaint(_MatrixRainPainter oldDelegate) => true;
}
