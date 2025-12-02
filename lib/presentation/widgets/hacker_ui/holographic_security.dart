import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:vector_math/vector_math.dart' as vm;

class HolographicSecurity extends StatefulWidget {
  final double rotationSpeed;
  final bool showThreats;
  
  const HolographicSecurity({
    super.key,
    this.rotationSpeed = 1.0,
    this.showThreats = true,
  });

  @override
  _HolographicSecurityState createState() => _HolographicSecurityState();
}

class _HolographicSecurityState extends State<HolographicSecurity> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<HolographicLayer> _layers = [];
  List<ThreatHologram> _threats = [];
  double _rotationX = 0;
  double _rotationY = 0;
  double _rotationZ = 0;
  final Random _random = Random();
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    _initializeHologram();
    _generateThreats();
    _startRotation();
  }
  
  void _initializeHologram() {
    // Create 7 holographic layers representing security levels
    _layers = List.generate(7, (index) {
      final radius = 50.0 + index * 40.0;
      final color = _getLayerColor(index);
      
      return HolographicLayer(
        radius: radius,
        color: color,
        opacity: 0.3 + (index * 0.1),
        rotationSpeed: 0.5 + index * 0.2,
        vertices: _generateVertices(radius, 8 + index * 2),
      );
    });
  }
  
  Color _getLayerColor(int index) {
    final colors = [
      Colors.blue,      // Network Layer
      Colors.green,     // Application Layer
      Colors.yellow,    // Data Layer
      Colors.orange,    // Access Layer
      Colors.red,       // Threat Layer
      Colors.purple,    // Quantum Layer
      Colors.cyan,      // Neural Layer
    ];
    return colors[index % colors.length];
  }
  
  List<vm.Vector3> _generateVertices(double radius, int count) {
    return List.generate(count, (i) {
      final angle = 2 * pi * i / count;
      return vm.Vector3(
        radius * cos(angle),
        radius * sin(angle),
        _random.nextDouble() * 20 - 10,
      );
    });
  }
  
  void _generateThreats() {
    if (!widget.showThreats) return;
    
    _threats = List.generate(15, (_) {
      final angle = _random.nextDouble() * 2 * pi;
      final distance = 30 + _random.nextDouble() * 200;
      
      return ThreatHologram(
        position: vm.Vector3(
          distance * cos(angle),
          distance * sin(angle),
          _random.nextDouble() * 100 - 50,
        ),
        color: _random.nextBool() ? Colors.red : Colors.orange,
        size: 3 + _random.nextDouble() * 7,
        pulseSpeed: 1 + _random.nextDouble() * 3,
        threatType: _randomThreatType(),
      );
    });
  }
  
  String _randomThreatType() {
    final types = [
      'Port Scan', 'DDoS', 'Malware', 'Phishing', 'MITM',
      'SQLi', 'XSS', 'Zero-Day', 'Ransomware', 'Botnet',
    ];
    return types[_random.nextInt(types.length)];
  }
  
  void _startRotation() {
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _rotationX += 0.005 * widget.rotationSpeed;
        _rotationY += 0.003 * widget.rotationSpeed;
        _rotationZ += 0.002 * widget.rotationSpeed;
        
        // Update threats
        for (final threat in _threats) {
          threat.position = _rotateVector(threat.position, 0.001);
          threat.pulsePhase += threat.pulseSpeed * 0.01;
        }
      });
    });
  }
  
  vm.Vector3 _rotateVector(vm.Vector3 vector, double angle) {
    final rotation = vm.Matrix3.rotationY(angle);
    return rotation.transform(vector);
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _rotationY += details.delta.dx * 0.01;
          _rotationX += details.delta.dy * 0.01;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [
              Colors.black.withOpacity(0.9),
              Colors.transparent,
            ],
          ),
        ),
        child: CustomPaint(
          painter: HolographicPainter(
            layers: _layers,
            threats: _threats,
            rotationX: _rotationX,
            rotationY: _rotationY,
            rotationZ: _rotationZ,
            time: _controller.value * 2 * pi,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class HolographicLayer {
  final double radius;
  final Color color;
  final double opacity;
  final double rotationSpeed;
  List<vm.Vector3> vertices;
  
  HolographicLayer({
    required this.radius,
    required this.color,
    required this.opacity,
    required this.rotationSpeed,
    required this.vertices,
  });
}

class ThreatHologram {
  vm.Vector3 position;
  final Color color;
  final double size;
  final double pulseSpeed;
  final String threatType;
  double pulsePhase = 0;
  
  ThreatHologram({
    required this.position,
    required this.color,
    required this.size,
    required this.pulseSpeed,
    required this.threatType,
  });
}

class HolographicPainter extends CustomPainter {
  final List<HolographicLayer> layers;
  final List<ThreatHologram> threats;
  final double rotationX;
  final double rotationY;
  final double rotationZ;
  final double time;
  
  HolographicPainter({
    required this.layers,
    required this.threats,
    required this.rotationX,
    required this.rotationY,
    required this.rotationZ,
    required this.time,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Draw connection grid
    _drawGrid(canvas, size, center);
    
    // Draw holographic layers
    for (final layer in layers) {
      _drawLayer(canvas, center, layer);
    }
    
    // Draw threats
    for (final threat in threats) {
      _drawThreat(canvas, center, threat);
    }
    
    // Draw security status text
    _drawStatus(canvas, size);
  }
  
  void _drawGrid(Canvas canvas, Size size, Offset center) {
    final gridPaint = Paint()
      ..color = Colors.cyan.withOpacity(0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    // Horizontal grid lines
    for (double y = -200; y <= 200; y += 50) {
      final start = Offset(center.dx - 200, center.dy + y);
      final end = Offset(center.dx + 200, center.dy + y);
      canvas.drawLine(start, end, gridPaint);
    }
    
    // Vertical grid lines
    for (double x = -200; x <= 200; x += 50) {
      final start = Offset(center.dx + x, center.dy - 200);
      final end = Offset(center.dx + x, center.dy + 200);
      canvas.drawLine(start, end, gridPaint);
    }
  }
  
  void _drawLayer(Canvas canvas, Offset center, HolographicLayer layer) {
    final rotatedVertices = layer.vertices.map((vertex) {
      return _rotateVertex(vertex, rotationX, rotationY, rotationZ);
    }).toList();
    
    // Draw layer as wireframe
    final wireframePaint = Paint()
      ..color = layer.color.withOpacity(layer.opacity * 0.5)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    
    // Connect vertices
    for (int i = 0; i < rotatedVertices.length; i++) {
      final start = rotatedVertices[i];
      final end = rotatedVertices[(i + 1) % rotatedVertices.length];
      
      canvas.drawLine(
        Offset(center.dx + start.x, center.dy + start.y),
        Offset(center.dx + end.x, center.dy + end.y),
        wireframePaint,
      );
    }
    
    // Draw glow effect
    final glowPaint = Paint()
      ..color = layer.color.withOpacity(layer.opacity * 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    
    canvas.drawCircle(
      center,
      layer.radius,
      glowPaint,
    );
  }
  
  void _drawThreat(Canvas canvas, Offset center, ThreatHologram threat) {
    final rotatedPos = _rotateVertex(threat.position, rotationX, rotationY, rotationZ);
    final pos = Offset(center.dx + rotatedPos.x, center.dy + rotatedPos.y);
    
    // Pulsing effect
    final pulseSize = threat.size * (1 + sin(threat.pulsePhase) * 0.3);
    
    // Outer glow
    final glowPaint = Paint()
      ..color = threat.color.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    
    canvas.drawCircle(pos, pulseSize * 1.5, glowPaint);
    
    // Inner core
    final corePaint = Paint()
      ..color = threat.color.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(pos, pulseSize, corePaint);
    
    // Draw threat type label
    final textPainter = TextPainter(
      text: TextSpan(
        text: threat.threatType,
        style: TextStyle(
          color: threat.color,
          fontSize: 10,
          fontFamily: 'ShareTechMono',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(canvas, pos + const Offset(-20, 15));
    
    // Draw connection line to center
    final connectionPaint = Paint()
      ..color = threat.color.withOpacity(0.2)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;
    
    canvas.drawLine(center, pos, connectionPaint);
  }
  
  vm.Vector3 _rotateVertex(vm.Vector3 vertex, double rx, double ry, double rz) {
    // Apply rotations
    var rotated = vertex.clone();
    
    // Rotate around X axis
    final cosX = cos(rx);
    final sinX = sin(rx);
    final y1 = rotated.y * cosX - rotated.z * sinX;
    final z1 = rotated.y * sinX + rotated.z * cosX;
    rotated = vm.Vector3(rotated.x, y1, z1);
    
    // Rotate around Y axis
    final cosY = cos(ry);
    final sinY = sin(ry);
    final x2 = rotated.x * cosY + rotated.z * sinY;
    final z2 = -rotated.x * sinY + rotated.z * cosY;
    rotated = vm.Vector3(x2, rotated.y, z2);
    
    // Rotate around Z axis
    final cosZ = cos(rz);
    final sinZ = sin(rz);
    final x3 = rotated.x * cosZ - rotated.y * sinZ;
    final y3 = rotated.x * sinZ + rotated.y * cosZ;
    rotated = vm.Vector3(x3, y3, rotated.z);
    
    return rotated;
  }
  
  void _drawStatus(Canvas canvas, Size size) {
    final statusText = TextPainter(
      text: TextSpan(
        text: 'HOLOGRAPHIC SECURITY MATRIX\n'
              '7-LAYER DEFENSE ACTIVE\n'
              '${threats.length} THREATS MONITORED',
        style: const TextStyle(
          color: Colors.cyan,
          fontSize: 12,
          fontFamily: 'ShareTechMono',
          height: 1.5,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    
    statusText.layout(maxWidth: size.width - 40);
    statusText.paint(
      canvas,
      Offset(20, size.height - statusText.height - 20),
    );
  }
  
  @override
  bool shouldRepaint(HolographicPainter oldDelegate) => true;
}