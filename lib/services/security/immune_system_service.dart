import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImmuneSystemService with ChangeNotifier {
  final List<WhiteBloodCell> _whiteBloodCells = [];
  final List<DigitalVirus> _viruses = [];
  final List<Antibody> _antibodies = [];
  final List<MemoryCell> _memoryCells = [];
  final Random _random = Random();
  double _immuneStrength = 100.0;
  int _virusesNeutralized = 0;
  
  double get immuneStrength => _immuneStrength;
  int get whiteBloodCellCount => _whiteBloodCells.length;
  int get virusCount => _viruses.length;
  int get antibodiesCount => _antibodies.length;
  int get virusesNeutralized => _virusesNeutralized;
  
  Future<void> initialize() async {
    // Initialize with 50 white blood cells
    for (int i = 0; i < 50; i++) {
      _whiteBloodCells.add(WhiteBloodCell(
        id: 'WBC_$i',
        position: Offset(
          _random.nextDouble() * 1000,
          _random.nextDouble() * 1000,
        ),
        strength: 0.5 + _random.nextDouble() * 0.5,
        speed: 1 + _random.nextDouble() * 2,
        targetVirus: null,
      ));
    }
    
    // Start immune system cycle
    _startImmuneCycle();
    notifyListeners();
  }
  
  void _startImmuneCycle() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _updateImmuneSystem();
      _detectAndFightViruses();
      _produceAntibodies();
      _updateMemoryCells();
      
      notifyListeners();
    });
  }
  
  void _updateImmuneSystem() {
    // Update white blood cells
    for (final cell in _whiteBloodCells) {
      if (cell.targetVirus != null) {
        // Move towards target virus
        final direction = cell.targetVirus!.position - cell.position;
        final distance = direction.distance;
        
        if (distance < 10) {
          // Attack virus
          cell.targetVirus!.health -= cell.strength * 10;
          if (cell.targetVirus!.health <= 0) {
            _viruses.remove(cell.targetVirus);
            _virusesNeutralized++;
            cell.targetVirus = null;
            _immuneStrength += 0.1;
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
      }
      
      // Keep in bounds
      cell.position = Offset(
        cell.position.dx.clamp(0.0, 1000.0),
        cell.position.dy.clamp(0.0, 1000.0),
      );
    }
    
    // Update viruses
    for (final virus in _viruses) {
      virus.position += Offset(
        (_random.nextDouble() - 0.5) * virus.speed,
        (_random.nextDouble() - 0.5) * virus.speed,
      );
      
      // Damage immune system
      _immuneStrength -= virus.damageRate * 0.01;
    }
    
    // Update antibodies
    for (final antibody in _antibodies) {
      antibody.position += Offset(
        (_random.nextDouble() - 0.5) * antibody.speed,
        (_random.nextDouble() - 0.5) * antibody.speed,
      );
      
      // Antibodies degrade over time
      antibody.potency -= 0.001;
      if (antibody.potency <= 0) {
        _antibodies.remove(antibody);
        break;
      }
    }
    
    // Clamp immune strength
    _immuneStrength = _immuneStrength.clamp(0.0, 100.0);
  }
  
  void _detectAndFightViruses() {
    // White blood cells detect and target viruses
    for (final cell in _whiteBloodCells) {
      if (cell.targetVirus == null) {
        // Find nearest virus
        DigitalVirus? nearestVirus;
        double nearestDistance = double.infinity;
        
        for (final virus in _viruses) {
          final distance = (cell.position - virus.position).distance;
          if (distance < nearestDistance) {
            nearestDistance = distance;
            nearestVirus = virus;
          }
        }
        
        if (nearestVirus != null && nearestDistance < 100) {
          cell.targetVirus = nearestVirus;
        }
      }
    }
    
    // Antibodies neutralize viruses
    for (final antibody in _antibodies) {
      for (final virus in _viruses) {
        final distance = (antibody.position - virus.position).distance;
        if (distance < 20) {
          virus.health -= antibody.potency * 5;
          antibody.potency *= 0.9; // Reduce potency after attack
          
          if (virus.health <= 0) {
            _viruses.remove(virus);
            _virusesNeutralized++;
            _immuneStrength += 0.5;
            
            // Create memory cell
            _memoryCells.add(MemoryCell(
              virusSignature: virus.signature,
              created: DateTime.now(),
              effectiveness: 0.8 + _random.nextDouble() * 0.2,
            ));
            break;
          }
        }
      }
    }
  }
  
  void _produceAntibodies() {
    // Produce antibodies based on virus presence
    if (_viruses.isNotEmpty && _random.nextDouble() < 0.1) {
      _antibodies.add(Antibody(
        id: 'AB_${DateTime.now().millisecondsSinceEpoch}',
        position: Offset(
          _random.nextDouble() * 1000,
          _random.nextDouble() * 1000,
        ),
        speed: 1 + _random.nextDouble() * 2,
        potency: 0.5 + _random.nextDouble() * 0.5,
        targetSignature: _viruses.first.signature,
      ));
    }
  }
  
  void _updateMemoryCells() {
    // Remove old memory cells
    _memoryCells.removeWhere((cell) => 
      DateTime.now().difference(cell.created).inDays > 30
    );
  }
  
  void simulateVirusAttack() {
    // Add a new virus
    final virusTypes = [
      'Trojan-Dropper',
      'Ransomware-X',
      'Spyware-7',
      'Worm-Z',
      'Zero-Day',
    ];
    
    _viruses.add(DigitalVirus(
      id: 'VIRUS_${_viruses.length + 1}',
      signature: virusTypes[_random.nextInt(virusTypes.length)],
      position: Offset(
        _random.nextDouble() * 1000,
        _random.nextDouble() * 1000,
      ),
      speed: 0.5 + _random.nextDouble() * 1,
      health: 50 + _random.nextDouble() * 50,
      damageRate: 0.1 + _random.nextDouble() * 0.3,
      replicationRate: 0.01,
    ));
    
    notifyListeners();
  }
  
  void boostImmunity() {
    // Add more white blood cells
    for (int i = 0; i < 10; i++) {
      _whiteBloodCells.add(WhiteBloodCell(
        id: 'WBC_BOOST_${_whiteBloodCells.length}',
        position: Offset(
          _random.nextDouble() * 1000,
          _random.nextDouble() * 1000,
        ),
        strength: 0.7 + _random.nextDouble() * 0.3,
        speed: 2 + _random.nextDouble() * 2,
        targetVirus: null,
      ));
    }
    
    _immuneStrength += 5;
    _immuneStrength = _immuneStrength.clamp(0.0, 100.0);
    
    notifyListeners();
  }
  
  void createVaccine() {
    // Create vaccine from memory cells
    if (_memoryCells.isNotEmpty) {
      for (int i = 0; i < 5; i++) {
        _antibodies.add(Antibody(
          id: 'VACCINE_${DateTime.now().millisecondsSinceEpoch}_$i',
          position: Offset(
            _random.nextDouble() * 1000,
            _random.nextDouble() * 1000,
          ),
          speed: 2 + _random.nextDouble() * 2,
          potency: 0.8 + _random.nextDouble() * 0.2,
          targetSignature: _memoryCells.first.virusSignature,
        ));
      }
      
      notifyListeners();
    }
  }
  
  void shareImmunityData() {
    // Simulate sharing immunity data
    print('Sharing immunity data with trust cluster...');
    // In real implementation, this would share with federated learning
  }
  
  Map<String, dynamic> getImmuneStatus() {
    return {
      'immune_strength': _immuneStrength,
      'white_blood_cells': _whiteBloodCells.length,
      'active_viruses': _viruses.length,
      'antibodies': _antibodies.length,
      'memory_cells': _memoryCells.length,
      'viruses_neutralized': _virusesNeutralized,
      'immune_system_health': _getHealthStatus(),
      'last_virus_detection': _viruses.isEmpty ? null : DateTime.now(),
      'vaccine_ready': _memoryCells.length >= 3,
    };
  }
  
  String _getHealthStatus() {
    if (_immuneStrength > 80) return 'EXCELLENT';
    if (_immuneStrength > 60) return 'GOOD';
    if (_immuneStrength > 40) return 'FAIR';
    if (_immuneStrength > 20) return 'WEAK';
    return 'CRITICAL';
  }
}

class WhiteBloodCell {
  String id;
  Offset position;
  double strength;
  double speed;
  DigitalVirus? targetVirus;
  
  WhiteBloodCell({
    required this.id,
    required this.position,
    required this.strength,
    required this.speed,
    required this.targetVirus,
  });
}

class DigitalVirus {
  String id;
  String signature;
  Offset position;
  double speed;
  double health;
  double damageRate;
  double replicationRate;
  
  DigitalVirus({
    required this.id,
    required this.signature,
    required this.position,
    required this.speed,
    required this.health,
    required this.damageRate,
    required this.replicationRate,
  });
}

class Antibody {
  String id;
  Offset position;
  double speed;
  double potency;
  String targetSignature;
  
  Antibody({
    required this.id,
    required this.position,
    required this.speed,
    required this.potency,
    required this.targetSignature,
  });
}

class MemoryCell {
  String virusSignature;
  DateTime created;
  double effectiveness;
  
  MemoryCell({
    required this.virusSignature,
    required this.created,
    required this.effectiveness,
  });
}