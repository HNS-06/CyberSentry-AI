import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';

class SwarmIntelligenceService with ChangeNotifier {
  final List<SwarmAgent> _agents = [];
  final Random _random = Random();
  bool _isSwarmActive = false;
  double _swarmIntelligence = 0.0;
  late Timer _updateTimer;
  
  List<SwarmAgent> get agents => _agents;
  bool get isSwarmActive => _isSwarmActive;
  double get swarmIntelligence => _swarmIntelligence;
  
  Future<void> initializeSwarm({int agentCount = 50}) async {
    _agents.clear();
    
    for (int i = 0; i < agentCount; i++) {
      final agent = SwarmAgent(
        id: 'AGENT_${i + 1}',
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        intelligence: 0.5 + _random.nextDouble() * 0.5,
      );
      _agents.add(agent);
    }
    
    _isSwarmActive = true;
    _startSwarmIntelligence();
  }
  
  void _startSwarmIntelligence() {
    _updateTimer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      for (var agent in _agents) {
        agent.x = (agent.x + (_random.nextDouble() - 0.5) * 0.1).clamp(0.0, 1.0);
        agent.y = (agent.y + (_random.nextDouble() - 0.5) * 0.1).clamp(0.0, 1.0);
      }
      
      _swarmIntelligence = _calculateSwarmIntelligence();
      notifyListeners();
    });
  }
  
  double _calculateSwarmIntelligence() {
    if (_agents.isEmpty) return 0.0;
    final avg = _agents.fold(0.0, (sum, agent) => sum + agent.intelligence) / _agents.length;
    return (avg * 100).clamp(0.0, 100.0);
  }
  
  Map<String, dynamic> getSwarmStatus() {
    return {
      'active_agents': _agents.length,
      'swarm_intelligence': _swarmIntelligence,
      'average_agent_intelligence': _agents.isNotEmpty 
          ? _agents.map((a) => a.intelligence).reduce((a, b) => a + b) / _agents.length 
          : 0.0,
      'swarm_health': 'OPTIMAL',
      'last_update': DateTime.now(),
    };
  }
  
  void stopSwarm() {
    _isSwarmActive = false;
    notifyListeners();
  }
  
  void restartSwarm() {
    _isSwarmActive = true;
    notifyListeners();
  }
  
  @override
  void dispose() {
    _updateTimer.cancel();
    super.dispose();
  }
}

class SwarmAgent {
  final String id;
  double x;
  double y;
  final double intelligence;
  
  SwarmAgent({
    required this.id,
    required this.x,
    required this.y,
    required this.intelligence,
  });
}