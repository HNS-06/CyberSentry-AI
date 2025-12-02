import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class CyberGarden extends StatefulWidget {
  final double growthRate;
  final bool showThreats;
  
  const CyberGarden({
    super.key,
    this.growthRate = 1.0,
    this.showThreats = true,
  });

  @override
  _CyberGardenState createState() => _CyberGardenState();
}

class _CyberGardenState extends State<CyberGarden> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<DigitalPlant> _plants = [];
  List<CyberThreat> _threats = [];
  List<DefenseSpecies> _defenses = [];
  double _gardenHealth = 100.0;
  double _securityScore = 85.0;
  final Random _random = Random();
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _initializeGarden();
    _startGardenCycle();
  }
  
  void _initializeGarden() {
    // Initialize defense plants
    _defenses = [
      DefenseSpecies(
        name: 'Neural Firewall',
        type: DefenseType.firewall,
        position: const Offset(0.3, 0.3),
        size: 1.0,
        health: 100,
        growthStage: 3,
      ),
      DefenseSpecies(
        name: 'Quantum Encryptor',
        type: DefenseType.quantum,
        position: const Offset(0.7, 0.3),
        size: 0.8,
        health: 90,
        growthStage: 2,
      ),
      DefenseSpecies(
        name: 'Honeypot Trap',
        type: DefenseType.honeypot,
        position: const Offset(0.2, 0.7),
        size: 0.7,
        health: 80,
        growthStage: 2,
      ),
      DefenseSpecies(
        name: 'Behavior Analyzer',
        type: DefenseType.behavior,
        position: const Offset(0.8, 0.7),
        size: 0.9,
        health: 95,
        growthStage: 3,
      ),
    ];
    
    // Generate random plants
    _plants = List.generate(20, (_) => _generateRandomPlant());
    
    // Generate initial threats
    if (widget.showThreats) {
      _threats = List.generate(5, (_) => _generateRandomThreat());
    }
  }
  
  DigitalPlant _generateRandomPlant() {
    final types = PlantType.values;
    return DigitalPlant(
      type: types[_random.nextInt(types.length)],
      position: Offset(_random.nextDouble(), _random.nextDouble()),
      size: 0.5 + _random.nextDouble() * 0.5,
      health: 60 + _random.nextDouble() * 40,
      growth: _random.nextDouble(),
      color: Color.fromRGBO(
        _random.nextInt(100) + 100,  // Green dominant
        _random.nextInt(150) + 100,
        _random.nextInt(100) + 100,
        1.0,
      ),
    );
  }
  
  CyberThreat _generateRandomThreat() {
    final threatTypes = [
      ThreatType.virus,
      ThreatType.worm,
      ThreatType.trojan,
      ThreatType.spyware,
      ThreatType.ransomware,
    ];
    
    return CyberThreat(
      type: threatTypes[_random.nextInt(threatTypes.length)],
      position: Offset(_random.nextDouble(), _random.nextDouble()),
      size: 0.3 + _random.nextDouble() * 0.4,
      speed: 0.001 + _random.nextDouble() * 0.003,
      damageRate: 0.1 + _random.nextDouble() * 0.2,
    );
  }
  
  void _startGardenCycle() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        // Update plants
        for (final plant in _plants) {
          plant.growth += 0.001 * widget.growthRate;
          if (plant.growth > 1.0) plant.growth = 1.0;
          
          // Random health fluctuations
          plant.health += (_random.nextDouble() - 0.5) * 0.2;
          plant.health = plant.health.clamp(0.0, 100.0);
        }
        
        // Update threats
        for (final threat in _threats) {
          threat.position += Offset(
            (threat.speed * _random.nextDouble() - threat.speed / 2),
            (threat.speed * _random.nextDouble() - threat.speed / 2),
          );
          
          // Keep threats in bounds
          threat.position = Offset(
            threat.position.dx.clamp(0.0, 1.0),
            threat.position.dy.clamp(0.0, 1.0),
          );
          
          // Damage nearby plants
          for (final plant in _plants) {
            final distance = (threat.position - plant.position).distance;
            if (distance < threat.size * 0.1) {
              plant.health -= threat.damageRate;
            }
          }
        }
        
        // Defenses protect against threats
        for (final defense in _defenses) {
          for (final threat in _threats) {
            final distance = (threat.position - defense.position).distance;
            if (distance < defense.size * 0.2) {
              // Defense neutralizes threat
              threat.health -= defense.growthStage * 5;
              if (threat.health <= 0) {
                _threats.remove(threat);
                _gardenHealth += 5;
                break;
              }
            }
          }
        }
        
        // Update garden health based on plant health
        final avgPlantHealth = _plants.isEmpty 
            ? 0 
            : _plants.map((p) => p.health).reduce((a, b) => a + b) / _plants.length;
        
        _gardenHealth = (avgPlantHealth * 0.7 + _securityScore * 0.3);
        _securityScore = 100 - (_threats.length * 5).toDouble();
        
        // Occasionally spawn new threats
        if (widget.showThreats && _random.nextDouble() < 0.01) {
          _threats.add(_generateRandomThreat());
        }
        
        // Occasionally spawn new plants
        if (_random.nextDouble() < 0.005) {
          _plants.add(_generateRandomPlant());
        }
      });
    });
  }
  
  void _waterGarden() {
    setState(() {
      for (final plant in _plants) {
        plant.health += 5;
        plant.health = plant.health.clamp(0.0, 100.0);
      }
      _gardenHealth += 10;
      _gardenHealth = _gardenHealth.clamp(0.0, 100.0);
    });
  }
  
  void _addDefense(DefenseType type) {
    setState(() {
      _defenses.add(DefenseSpecies(
        name: _getDefenseName(type),
        type: type,
        position: Offset(_random.nextDouble(), _random.nextDouble()),
        size: 0.5,
        health: 100,
        growthStage: 1,
      ));
    });
  }
  
  String _getDefenseName(DefenseType type) {
    switch (type) {
      case DefenseType.firewall:
        return 'Firewall Seed';
      case DefenseType.quantum:
        return 'Quantum Spore';
      case DefenseType.honeypot:
        return 'Honeypot Vine';
      case DefenseType.behavior:
        return 'Behavior Blossom';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.9),
            const Color(0xFF002200).withOpacity(0.7),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Garden visualization
          CustomPaint(
            painter: GardenPainter(
              plants: _plants,
              threats: _threats,
              defenses: _defenses,
              gardenHealth: _gardenHealth,
              time: _controller.value * 2 * pi,
            ),
            size: Size.infinite,
          ),
          
          // Stats overlay
          Positioned(
            top: 20,
            left: 20,
            child: _buildStatsPanel(),
          ),
          
          // Controls
          Positioned(
            bottom: 20,
            right: 20,
            child: _buildControls(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatsPanel() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CYBER GARDEN',
            style: TextStyle(
              color: Colors.green,
              fontFamily: 'ShareTechMono',
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          _buildStatRow('Garden Health', _gardenHealth, Colors.green),
          _buildStatRow('Security Score', _securityScore, Colors.cyan),
          _buildStatRow('Plants', _plants.length.toDouble(), Colors.lightGreen),
          _buildStatRow('Defenses', _defenses.length.toDouble(), Colors.blue),
          _buildStatRow('Threats', _threats.length.toDouble(), Colors.red),
        ],
      ),
    );
  }
  
  Widget _buildStatRow(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 20),
          Container(
            width: 100,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${value.toInt()}%',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontFamily: 'ShareTechMono',
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildControls() {
    return Row(
      children: [
        _buildControlButton(
          icon: Icons.opacity,
          color: Colors.blue,
          onPressed: _waterGarden,
          label: 'Water',
        ),
        const SizedBox(width: 10),
        _buildControlButton(
          icon: Icons.security,
          color: Colors.green,
          onPressed: () => _addDefense(DefenseType.firewall),
          label: 'Firewall',
        ),
        const SizedBox(width: 10),
        _buildControlButton(
          icon: Icons.vpn_key,
          color: Colors.purple,
          onPressed: () => _addDefense(DefenseType.quantum),
          label: 'Quantum',
        ),
      ],
    );
  }
  
  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: color),
          ),
          child: IconButton(
            icon: Icon(icon, color: color),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

enum PlantType { firewall, encryption, honeypot, biometric, neural }
enum ThreatType { virus, worm, trojan, spyware, ransomware }
enum DefenseType { firewall, quantum, honeypot, behavior }

class DigitalPlant {
  PlantType type;
  Offset position;
  double size;
  double health;
  double growth;
  Color color;
  
  DigitalPlant({
    required this.type,
    required this.position,
    required this.size,
    required this.health,
    required this.growth,
    required this.color,
  });
}

class CyberThreat {
  ThreatType type;
  Offset position;
  double size;
  double speed;
  double damageRate;
  double health = 100;
  
  CyberThreat({
    required this.type,
    required this.position,
    required this.size,
    required this.speed,
    required this.damageRate,
  });
}

class DefenseSpecies {
  String name;
  DefenseType type;
  Offset position;
  double size;
  double health;
  int growthStage;
  
  DefenseSpecies({
    required this.name,
    required this.type,
    required this.position,
    required this.size,
    required this.health,
    required this.growthStage,
  });
}

class GardenPainter extends CustomPainter {
  final List<DigitalPlant> plants;
  final List<CyberThreat> threats;
  final List<DefenseSpecies> defenses;
  final double gardenHealth;
  final double time;
  
  GardenPainter({
    required this.plants,
    required this.threats,
    required this.defenses,
    required this.gardenHealth,
    required this.time,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Draw garden background
    _drawBackground(canvas, size);
    
    // Draw connection network
    _drawConnections(canvas, size);
    
    // Draw plants
    for (final plant in plants) {
      _drawPlant(canvas, size, plant);
    }
    
    // Draw defenses
    for (final defense in defenses) {
      _drawDefense(canvas, size, defense);
    }
    
    // Draw threats
    for (final threat in threats) {
      _drawThreat(canvas, size, threat);
    }
    
    // Draw garden aura
    _drawAura(canvas, center);
  }
  
  void _drawBackground(Canvas canvas, Size size) {
    // Draw cyber soil
    final soilPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF003300).withOpacity(0.8),
          const Color(0xFF001100).withOpacity(0.9),
        ],
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));
    
    canvas.drawRect(Offset.zero & size, soilPaint);
    
    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.green.withOpacity(0.1)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;
    
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }
  
  void _drawConnections(Canvas canvas, Size size) {
    final connectionPaint = Paint()
      ..color = Colors.green.withOpacity(0.2)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;
    
    // Connect plants to nearest defenses
    for (final plant in plants) {
      for (final defense in defenses) {
        final distance = (plant.position - defense.position).distance;
        if (distance < 0.3) {
          final start = Offset(
            plant.position.dx * size.width,
            plant.position.dy * size.height,
          );
          final end = Offset(
            defense.position.dx * size.width,
            defense.position.dy * size.height,
          );
          
          canvas.drawLine(start, end, connectionPaint);
          
          // Draw data flow particles
          final progress = (time / (2 * pi) * 2) % 1;
          final particlePos = Offset.lerp(start, end, progress)!;
          
          final particlePaint = Paint()
            ..color = Colors.green.withOpacity(0.8)
            ..style = PaintingStyle.fill;
          
          canvas.drawCircle(particlePos, 2, particlePaint);
        }
      }
    }
  }
  
  void _drawPlant(Canvas canvas, Size size, DigitalPlant plant) {
    final pos = Offset(
      plant.position.dx * size.width,
      plant.position.dy * size.height,
    );
    
    final plantSize = 20 * plant.size * plant.growth;
    
    // Draw different plant types
    switch (plant.type) {
      case PlantType.firewall:
        _drawFirewallPlant(canvas, pos, plantSize, plant.health);
        break;
      case PlantType.encryption:
        _drawEncryptionPlant(canvas, pos, plantSize, plant.health);
        break;
      case PlantType.honeypot:
        _drawHoneypotPlant(canvas, pos, plantSize, plant.health);
        break;
      case PlantType.biometric:
        _drawBiometricPlant(canvas, pos, plantSize, plant.health);
        break;
      case PlantType.neural:
        _drawNeuralPlant(canvas, pos, plantSize, plant.health);
        break;
    }
    
    // Draw health indicator
    final healthPaint = Paint()
      ..color = _getHealthColor(plant.health)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    canvas.drawCircle(pos, plantSize + 5, healthPaint);
  }
  
  void _drawFirewallPlant(Canvas canvas, Offset pos, double size, double health) {
    // Draw as layered circles
    for (int i = 0; i < 3; i++) {
      final layerPaint = Paint()
        ..color = Colors.green.withOpacity(0.3 + i * 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      
      final layerSize = size * (1 - i * 0.3);
      canvas.drawCircle(pos, layerSize, layerPaint);
    }
    
    // Draw center core
    final corePaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(pos, size * 0.3, corePaint);
  }
  
  void _drawEncryptionPlant(Canvas canvas, Offset pos, double size, double health) {
    // Draw as rotating gears
    final gearPaint = Paint()
      ..color = Colors.purple.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    
    for (int i = 0; i < 6; i++) {
      final angle = 2 * pi * i / 6 + time;
      final gearPos = Offset(
        pos.dx + cos(angle) * size,
        pos.dy + sin(angle) * size,
      );
      
      canvas.drawCircle(gearPos, size * 0.4, gearPaint);
    }
    
    // Draw center lock
    final lockPaint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(pos, size * 0.5, lockPaint);
  }
  
  void _drawHoneypotPlant(Canvas canvas, Offset pos, double size, double health) {
    // Draw as honeycomb pattern
    final honeyPaint = Paint()
      ..color = Colors.orange.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    
    // Draw hexagon
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = 2 * pi * i / 6;
      final x = pos.dx + cos(angle) * size;
      final y = pos.dy + sin(angle) * size;
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    
    canvas.drawPath(path, honeyPaint);
  }
  
  void _drawBiometricPlant(Canvas canvas, Offset pos, double size, double health) {
    // Draw as fingerprint pattern
    final bioPaint = Paint()
      ..color = Colors.cyan.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    for (double r = size * 0.3; r <= size; r += size * 0.2) {
      for (double a = 0; a < 2 * pi; a += pi / 6) {
        final wave = sin(time + a * 3) * r * 0.1;
        final x = pos.dx + cos(a) * (r + wave);
        final y = pos.dy + sin(a) * (r + wave);
        
        canvas.drawCircle(Offset(x, y), 1, bioPaint);
      }
    }
  }
  
  void _drawNeuralPlant(Canvas canvas, Offset pos, double size, double health) {
    // Draw as neural network node
    final neuralPaint = Paint()
      ..color = Colors.blue.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(pos, size, neuralPaint);
    
    // Draw pulsing core
    final pulseSize = size * 0.5 * (1 + sin(time * 3) * 0.3);
    final pulsePaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(pos, pulseSize, pulsePaint);
  }
  
  void _drawDefense(Canvas canvas, Size size, DefenseSpecies defense) {
    final pos = Offset(
      defense.position.dx * size.width,
      defense.position.dy * size.height,
    );
    
    final defenseSize = 30 * defense.size;
    
    // Draw defense based on type
    final defensePaint = Paint()
      ..color = _getDefenseColor(defense.type)
      ..style = PaintingStyle.fill;
    
    // Draw different defense types
    switch (defense.type) {
      case DefenseType.firewall:
        canvas.drawRect(
          Rect.fromCenter(center: pos, width: defenseSize, height: defenseSize),
          defensePaint,
        );
        break;
      case DefenseType.quantum:
        canvas.drawCircle(pos, defenseSize, defensePaint);
        break;
      case DefenseType.honeypot:
        final path = Path();
        path.addPolygon([
          pos + Offset(-defenseSize, 0),
          pos + Offset(0, -defenseSize),
          pos + Offset(defenseSize, 0),
          pos + Offset(0, defenseSize),
        ], true);
        canvas.drawPath(path, defensePaint);
        break;
      case DefenseType.behavior:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: pos, width: defenseSize, height: defenseSize),
            Radius.circular(defenseSize / 4),
          ),
          defensePaint,
        );
        break;
    }
    
    // Draw protection radius
    final radiusPaint = Paint()
      ..color = _getDefenseColor(defense.type).withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    canvas.drawCircle(pos, defenseSize * 3, radiusPaint);
    
    // Draw defense label
    final textPainter = TextPainter(
      text: TextSpan(
        text: defense.name.substring(0, 1),
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(
      canvas,
      pos - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }
  
  void _drawThreat(Canvas canvas, Size size, CyberThreat threat) {
    final pos = Offset(
      threat.position.dx * size.width,
      threat.position.dy * size.height,
    );
    
    final threatSize = 15 * threat.size;
    
    // Draw threat based on type
    final threatPaint = Paint()
      ..color = _getThreatColor(threat.type)
      ..style = PaintingStyle.fill;
    
    // Draw different threat shapes
    switch (threat.type) {
      case ThreatType.virus:
        // Spiky circle
        final path = Path();
        for (int i = 0; i < 8; i++) {
          final angle = 2 * pi * i / 8;
          final spikeAngle = angle + time;
          final distance = threatSize * (1 + sin(spikeAngle * 4) * 0.3);
          final x = pos.dx + cos(angle) * distance;
          final y = pos.dy + sin(angle) * distance;
          
          if (i == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        path.close();
        canvas.drawPath(path, threatPaint);
        break;
        
      case ThreatType.worm:
        // Wavy line
        final path = Path();
        for (double t = 0; t < 2 * pi; t += 0.1) {
          final x = pos.dx + cos(t) * threatSize * (1 + sin(t * 3 + time) * 0.2);
          final y = pos.dy + sin(t) * threatSize * (1 + cos(t * 3 + time) * 0.2);
          
          if (t == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        canvas.drawPath(path, threatPaint);
        break;
        
      default:
        // Default circle
        canvas.drawCircle(pos, threatSize, threatPaint);
        break;
    }
    
    // Draw threat movement trail
    final trailPaint = Paint()
      ..color = _getThreatColor(threat.type).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    // Simulate trail
    for (int i = 1; i <= 3; i++) {
      final trailPos = Offset(
        pos.dx - i * 2,
        pos.dy - i * 2,
      );
      canvas.drawCircle(trailPos, threatSize * 0.7, trailPaint);
    }
  }
  
  void _drawAura(Canvas canvas, Offset center) {
    // Draw garden health aura
    final auraPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          _getHealthColor(gardenHealth).withOpacity(0.1),
          Colors.transparent,
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: 300))
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, 300, auraPaint);
  }
  
  Color _getHealthColor(double health) {
    if (health > 75) return Colors.green;
    if (health > 50) return Colors.yellow;
    if (health > 25) return Colors.orange;
    return Colors.red;
  }
  
  Color _getDefenseColor(DefenseType type) {
    switch (type) {
      case DefenseType.firewall:
        return Colors.green;
      case DefenseType.quantum:
        return Colors.purple;
      case DefenseType.honeypot:
        return Colors.orange;
      case DefenseType.behavior:
        return Colors.cyan;
    }
  }
  
  Color _getThreatColor(ThreatType type) {
    switch (type) {
      case ThreatType.virus:
        return Colors.red;
      case ThreatType.worm:
        return Colors.pink;
      case ThreatType.trojan:
        return Colors.deepOrange;
      case ThreatType.spyware:
        return Colors.yellow;
      case ThreatType.ransomware:
        return Colors.redAccent;
    }
  }
  
  @override
  bool shouldRepaint(GardenPainter oldDelegate) => true;
}