import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class DigitalImmuneSystem extends StatefulWidget {
  final bool showWhiteBloodCells;
  final bool showViruses;
  final bool showAntibodies;
  
  const DigitalImmuneSystem({
    super.key,
    this.showWhiteBloodCells = true,
    this.showViruses = true,
    this.showAntibodies = true,
  });

  @override
  _DigitalImmuneSystemState createState() => _DigitalImmuneSystemState();
}

class _DigitalImmuneSystemState extends State<DigitalImmuneSystem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<WhiteBloodCellViz> _whiteBloodCells = [];
  List<VirusViz> _viruses = [];
  List<AntibodyViz> _antibodies = [];
  List<MemoryCellViz> _memoryCells = [];
  double _immuneStrength = 100.0;
  int _virusesNeutralized = 0;
  final Random _random = Random();
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _initializeImmuneSystem();
    _startImmuneCycle();
  }
  
  void _initializeImmuneSystem() {
    // Initialize white blood cells
    _whiteBloodCells = List.generate(50, (index) {
      return WhiteBloodCellViz(
        id: 'wbc_$index',
        position: Offset(
          _random.nextDouble() * 500,
          _random.nextDouble() * 500,
        ),
        size: 8 + _random.nextDouble() * 4,
        speed: 0.5 + _random.nextDouble() * 1,
        strength: 0.5 + _random.nextDouble() * 0.5,
        targetVirus: null,
      );
    });
    
    // Initialize some viruses
    if (widget.showViruses) {
      _viruses = List.generate(10, (index) {
        return VirusViz(
          id: 'virus_$index',
          position: Offset(
            _random.nextDouble() * 500,
            _random.nextDouble() * 500,
          ),
          size: 6 + _random.nextDouble() * 4,
          speed: 0.2 + _random.nextDouble() * 0.3,
          health: 50 + _random.nextDouble() * 50,
          type: VirusType.values[_random.nextInt(VirusType.values.length)],
        );
      });
    }
    
    // Initialize antibodies
    if (widget.showAntibodies) {
      _antibodies = List.generate(20, (index) {
        return AntibodyViz(
          id: 'ab_$index',
          position: Offset(
            _random.nextDouble() * 500,
            _random.nextDouble() * 500,
          ),
          size: 4 + _random.nextDouble() * 2,
          speed: 0.8 + _random.nextDouble() * 0.4,
          potency: 0.6 + _random.nextDouble() * 0.4,
        );
      });
    }
    
    // Initialize memory cells
    _memoryCells = List.generate(5, (index) {
      return MemoryCellViz(
        id: 'mc_$index',
        position: Offset(
          _random.nextDouble() * 500,
          _random.nextDouble() * 500,
        ),
        size: 10 + _random.nextDouble() * 5,
        effectiveness: 0.7 + _random.nextDouble() * 0.3,
      );
    });
  }
  
  void _startImmuneCycle() {
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      setState(() {
        _updateWhiteBloodCells();
        _updateViruses();
        _updateAntibodies();
        _updateMemoryCells();
        _detectAndFight();
        _updateImmuneStrength();
      });
    });
  }
  
  void _updateWhiteBloodCells() {
    for (final cell in _whiteBloodCells) {
      if (cell.targetVirus != null && cell.targetVirus!.health > 0) {
        // Move towards target virus
        final direction = cell.targetVirus!.position - cell.position;
        final distance = direction.distance;
        
        if (distance < cell.size) {
          // Attack virus
          cell.targetVirus!.health -= cell.strength * 10;
          if (cell.targetVirus!.health <= 0) {
            _viruses.remove(cell.targetVirus);
            _virusesNeutralized++;
            cell.targetVirus = null;
          }
        } else {
          // Move towards virus
          final normalized = direction / distance;
          cell.position += normalized * cell.speed;
        }
      } else {
        // Patrol randomly
        cell.position += Offset(
          (_random.nextDouble() - 0.5) * cell.speed,
          (_random.nextDouble() - 0.5) * cell.speed,
        );
        
        // Find new target
        if (cell.targetVirus == null && _viruses.isNotEmpty) {
          VirusViz? nearestVirus;
          double nearestDistance = double.infinity;
          
          for (final virus in _viruses) {
            final distance = (cell.position - virus.position).distance;
            if (distance < 100 && distance < nearestDistance) {
              nearestDistance = distance;
              nearestVirus = virus;
            }
          }
          
          cell.targetVirus = nearestVirus;
        }
      }
      
      // Keep in bounds
      cell.position = Offset(
        cell.position.dx.clamp(0.0, 500.0),
        cell.position.dy.clamp(0.0, 500.0),
      );
    }
  }
  
  void _updateViruses() {
    for (final virus in _viruses) {
      // Move randomly
      virus.position += Offset(
        (_random.nextDouble() - 0.5) * virus.speed,
        (_random.nextDouble() - 0.5) * virus.speed,
      );
      
      // Replicate occasionally
      if (_random.nextDouble() < 0.005 && _viruses.length < 50) {
        _viruses.add(VirusViz(
          id: 'virus_${_viruses.length}',
          position: virus.position + Offset(
            (_random.nextDouble() - 0.5) * 20,
            (_random.nextDouble() - 0.5) * 20,
          ),
          size: virus.size * (0.8 + _random.nextDouble() * 0.4),
          speed: virus.speed * (0.8 + _random.nextDouble() * 0.4),
          health: virus.health * (0.8 + _random.nextDouble() * 0.4),
          type: virus.type,
        ));
      }
      
      // Keep in bounds
      virus.position = Offset(
        virus.position.dx.clamp(0.0, 500.0),
        virus.position.dy.clamp(0.0, 500.0),
      );
    }
  }
  
  void _updateAntibodies() {
    for (final antibody in _antibodies) {
      // Move randomly but with purpose
      antibody.position += Offset(
        (_random.nextDouble() - 0.5) * antibody.speed,
        (_random.nextDouble() - 0.5) * antibody.speed,
      );
      
      // Degrade over time
      antibody.potency -= 0.001;
      if (antibody.potency <= 0) {
        _antibodies.remove(antibody);
        break;
      }
      
      // Keep in bounds
      antibody.position = Offset(
        antibody.position.dx.clamp(0.0, 500.0),
        antibody.position.dy.clamp(0.0, 500.0),
      );
    }
    
    // Produce new antibodies based on virus presence
    if (_viruses.isNotEmpty && _random.nextDouble() < 0.1) {
      _antibodies.add(AntibodyViz(
        id: 'ab_${_antibodies.length}',
        position: Offset(
          _random.nextDouble() * 500,
          _random.nextDouble() * 500,
        ),
        size: 4 + _random.nextDouble() * 2,
        speed: 0.8 + _random.nextDouble() * 0.4,
        potency: 0.6 + _random.nextDouble() * 0.4,
      ));
    }
  }
  
  void _updateMemoryCells() {
    // Memory cells don't move much
    for (final cell in _memoryCells) {
      // Slight movement
      cell.position += Offset(
        (_random.nextDouble() - 0.5) * 0.1,
        (_random.nextDouble() - 0.5) * 0.1,
      );
      
      // Keep in bounds
      cell.position = Offset(
        cell.position.dx.clamp(0.0, 500.0),
        cell.position.dy.clamp(0.0, 500.0),
      );
    }
  }
  
  void _detectAndFight() {
    // Antibodies neutralize viruses
    for (final antibody in _antibodies) {
      for (final virus in _viruses) {
        final distance = (antibody.position - virus.position).distance;
        if (distance < antibody.size + virus.size) {
          virus.health -= antibody.potency * 20;
          antibody.potency *= 0.9; // Reduce potency after attack
          
          if (virus.health <= 0) {
            _viruses.remove(virus);
            _virusesNeutralized++;
            
            // Create memory cell
            if (_memoryCells.length < 20) {
              _memoryCells.add(MemoryCellViz(
                id: 'mc_${_memoryCells.length}',
                position: virus.position,
                size: 10 + _random.nextDouble() * 5,
                effectiveness: 0.7 + _random.nextDouble() * 0.3,
              ));
            }
            break;
          }
        }
      }
    }
  }
  
  void _updateImmuneStrength() {
    final virusCount = _viruses.length;
    final wbcCount = _whiteBloodCells.length;
    final antibodyCount = _antibodies.length;
    final memoryCount = _memoryCells.length;
    
    // Calculate immune strength
    double strength = 100.0;
    
    // Penalty for viruses
    strength -= virusCount * 2;
    
    // Bonus for defenses
    strength += wbcCount * 0.1;
    strength += antibodyCount * 0.2;
    strength += memoryCount * 0.5;
    
    // Keep in bounds
    _immuneStrength = strength.clamp(0.0, 100.0);
  }
  
  void addVirus() {
    setState(() {
      _viruses.add(VirusViz(
        id: 'virus_${_viruses.length}',
        position: Offset(
          _random.nextDouble() * 500,
          _random.nextDouble() * 500,
        ),
        size: 6 + _random.nextDouble() * 4,
        speed: 0.2 + _random.nextDouble() * 0.3,
        health: 50 + _random.nextDouble() * 50,
        type: VirusType.values[_random.nextInt(VirusType.values.length)],
      ));
    });
  }
  
  void boostImmunity() {
    setState(() {
      // Add white blood cells
      for (int i = 0; i < 5; i++) {
        _whiteBloodCells.add(WhiteBloodCellViz(
          id: 'wbc_boost_${_whiteBloodCells.length}',
          position: Offset(
            _random.nextDouble() * 500,
            _random.nextDouble() * 500,
          ),
          size: 8 + _random.nextDouble() * 4,
          speed: 0.8 + _random.nextDouble() * 0.4,
          strength: 0.7 + _random.nextDouble() * 0.3,
          targetVirus: null,
        ));
      }
      
      // Add antibodies
      for (int i = 0; i < 3; i++) {
        _antibodies.add(AntibodyViz(
          id: 'ab_boost_${_antibodies.length}',
          position: Offset(
            _random.nextDouble() * 500,
            _random.nextDouble() * 500,
          ),
          size: 5 + _random.nextDouble() * 2,
          speed: 1.0 + _random.nextDouble() * 0.4,
          potency: 0.8 + _random.nextDouble() * 0.2,
        ));
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 500,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF003300).withOpacity(0.8),
            Colors.black.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.5)),
      ),
      child: Stack(
        children: [
          // Background grid
          CustomPaint(
            painter: _ImmuneGridPainter(),
          ),
          
          // Memory Cells
          for (final cell in _memoryCells)
            Positioned(
              left: cell.position.dx - cell.size,
              top: cell.position.dy - cell.size,
              child: Container(
                width: cell.size * 2,
                height: cell.size * 2,
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.3),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.purple,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.memory,
                    color: Colors.purple,
                    size: cell.size,
                  ),
                ),
              ),
            ),
          
          // Viruses
          if (widget.showViruses)
            for (final virus in _viruses)
              Positioned(
                left: virus.position.dx - virus.size,
                top: virus.position.dy - virus.size,
                child: Container(
                  width: virus.size * 2,
                  height: virus.size * 2,
                  decoration: BoxDecoration(
                    color: _getVirusColor(virus.type).withOpacity(0.6),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _getVirusColor(virus.type),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _getVirusColor(virus.type).withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      _getVirusIcon(virus.type),
                      color: Colors.white,
                      size: virus.size,
                    ),
                  ),
                ),
              ),
          
          // Antibodies
          if (widget.showAntibodies)
            for (final antibody in _antibodies)
              Positioned(
                left: antibody.position.dx - antibody.size,
                top: antibody.position.dy - antibody.size,
                child: Container(
                  width: antibody.size * 2,
                  height: antibody.size * 2,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.4),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blue,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.shield,
                      color: Colors.blue,
                      size: antibody.size,
                    ),
                  ),
                ),
              ),
          
          // White Blood Cells
          if (widget.showWhiteBloodCells)
            for (final cell in _whiteBloodCells)
              Positioned(
                left: cell.position.dx - cell.size,
                top: cell.position.dy - cell.size,
                child: Container(
                  width: cell.size * 2,
                  height: cell.size * 2,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.4),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.green,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.security,
                      color: Colors.green,
                      size: cell.size,
                    ),
                  ),
                ),
              ),
          
          // Stats overlay
          Positioned(
            bottom: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'IMMUNE SYSTEM',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontFamily: 'ShareTechMono',
                    ),
                  ),
                  Text(
                    'Strength: ${_immuneStrength.toInt()}%',
                    style: TextStyle(
                      color: _getStrengthColor(),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Viruses: ${_viruses.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Neutralized: $_virusesNeutralized',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getVirusColor(VirusType type) {
    switch (type) {
      case VirusType.trojan:
        return Colors.orange;
      case VirusType.worm:
        return Colors.red;
      case VirusType.ransomware:
        return Colors.deepOrange;
      case VirusType.spyware:
        return Colors.yellow;
      case VirusType.adware:
        return Colors.amber;
    }
  }
  
  IconData _getVirusIcon(VirusType type) {
    switch (type) {
      case VirusType.trojan:
        return Icons.hide_source;
      case VirusType.worm:
        return Icons.cable;
      case VirusType.ransomware:
        return Icons.lock;
      case VirusType.spyware:
        return Icons.remove_red_eye;
      case VirusType.adware:
        return Icons.ads_click;
    }
  }
  
  Color _getStrengthColor() {
    if (_immuneStrength > 75) return Colors.green;
    if (_immuneStrength > 50) return Colors.yellow;
    if (_immuneStrength > 25) return Colors.orange;
    return Colors.red;
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _ImmuneGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.withOpacity(0.1)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;
    
    // Draw grid
    for (double x = 0; x < size.width; x += 50) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 50) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }
  
  @override
  bool shouldRepaint(_ImmuneGridPainter oldDelegate) => false;
}

enum VirusType {
  trojan,
  worm,
  ransomware,
  spyware,
  adware,
}

class WhiteBloodCellViz {
  String id;
  Offset position;
  double size;
  double speed;
  double strength;
  VirusViz? targetVirus;
  
  WhiteBloodCellViz({
    required this.id,
    required this.position,
    required this.size,
    required this.speed,
    required this.strength,
    this.targetVirus,
  });
}

class VirusViz {
  String id;
  Offset position;
  double size;
  double speed;
  double health;
  VirusType type;
  
  VirusViz({
    required this.id,
    required this.position,
    required this.size,
    required this.speed,
    required this.health,
    required this.type,
  });
}

class AntibodyViz {
  String id;
  Offset position;
  double size;
  double speed;
  double potency;
  
  AntibodyViz({
    required this.id,
    required this.position,
    required this.size,
    required this.speed,
    required this.potency,
  });
}

class MemoryCellViz {
  String id;
  Offset position;
  double size;
  double effectiveness;
  
  MemoryCellViz({
    required this.id,
    required this.position,
    required this.size,
    required this.effectiveness,
  });
}