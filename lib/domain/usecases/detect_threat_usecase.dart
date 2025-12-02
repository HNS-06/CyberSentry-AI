import 'package:dartz/dartz.dart';
import 'package:cybersentry_ai/data/models/threat_model.dart';
import 'package:cybersentry_ai/data/repositories/threat_repository.dart';

class DetectThreatUseCase {
  final ThreatRepository repository;

  DetectThreatUseCase({required this.repository});

  Future<Either<String, ThreatModel>> execute({
    required String type,
    required String severity,
    required String source,
    required String target,
    Map<String, dynamic> metadata = const {},
    double confidence = 0.8,
  }) async {
    try {
      final threat = ThreatModel(
        id: 'DET_${DateTime.now().millisecondsSinceEpoch}',
        type: type,
        severity: severity,
        source: source,
        target: target,
        detectedAt: DateTime.now(),
        metadata: metadata,
        confidence: confidence,
        affectedSystems: _determineAffectedSystems(type),
        status: 'active',
        mitigation: 'Initial detection - analysis pending',
        riskScore: _calculateRiskScore(severity, confidence),
      );

      await repository.addThreat(threat);
      return Right(threat);
    } catch (e) {
      return Left('Failed to detect threat: $e');
    }
  }

  List<String> _determineAffectedSystems(String threatType) {
    final systems = <String>['Neural Firewall', 'Threat Analyzer'];
    
    switch (threatType) {
      case 'MALWARE':
        systems.addAll(['File Scanner', 'Behavior Monitor']);
        break;
      case 'PHISHING':
        systems.addAll(['Email Filter', 'URL Analyzer']);
        break;
      case 'DDoS':
        systems.addAll(['Network Monitor', 'Traffic Shaper']);
        break;
      case 'RANSOMWARE':
        systems.addAll(['File Backup', 'Encryption Monitor']);
        break;
      case 'ZERO-DAY':
        systems.addAll(['Anomaly Detector', 'Pattern Learner']);
        break;
    }
    
    return systems;
  }

  int _calculateRiskScore(String severity, double confidence) {
    int baseScore;
    
    switch (severity) {
      case 'CRITICAL':
        baseScore = 85;
        break;
      case 'HIGH':
        baseScore = 65;
        break;
      case 'MEDIUM':
        baseScore = 45;
        break;
      case 'LOW':
        baseScore = 25;
        break;
      default:
        baseScore = 50;
    }
    
    // Adjust score based on confidence
    final adjustedScore = (baseScore * confidence).toInt();
    return adjustedScore.clamp(0, 100);
  }
}

class AnalyzeThreatPatternUseCase {
  final ThreatRepository repository;

  AnalyzeThreatPatternUseCase({required this.repository});

  Future<Either<String, Map<String, dynamic>>> execute() async {
    try {
      final threats = await repository.getAllThreats();
      final recentThreats = threats
          .where((t) => t.detectedAt.isAfter(
              DateTime.now().subtract(const Duration(days: 30))))
          .toList();

      if (recentThreats.isEmpty) {
        return Right({'status': 'no_data', 'patterns': {}});
      }

      final patterns = _extractPatterns(recentThreats);
      return Right({
        'status': 'analysis_complete',
        'patterns': patterns,
        'threat_count': recentThreats.length,
        'time_period': '30 days',
        'confidence': _calculatePatternConfidence(patterns),
      });
    } catch (e) {
      return Left('Failed to analyze threat patterns: $e');
    }
  }

  Map<String, dynamic> _extractPatterns(List<ThreatModel> threats) {
    final patterns = <String, dynamic>{};
    
    // Count by type
    final typeCount = <String, int>{};
    for (final threat in threats) {
      typeCount[threat.type] = (typeCount[threat.type] ?? 0) + 1;
    }
    patterns['by_type'] = typeCount;
    
    // Count by severity
    final severityCount = <String, int>{};
    for (final threat in threats) {
      severityCount[threat.severity] = (severityCount[threat.severity] ?? 0) + 1;
    }
    patterns['by_severity'] = severityCount;
    
    // Time patterns
    final hourlyPattern = List<int>.filled(24, 0);
    for (final threat in threats) {
      hourlyPattern[threat.detectedAt.hour]++;
    }
    patterns['hourly_distribution'] = hourlyPattern;
    
    // Source analysis
    final sourcePattern = <String, int>{};
    for (final threat in threats) {
      final source = threat.source;
      if (sourcePattern.containsKey(source)) {
        sourcePattern[source] = sourcePattern[source]! + 1;
      } else {
        sourcePattern[source] = 1;
      }
    }
    patterns['source_distribution'] = sourcePattern;
    
    // Calculate threat density
    patterns['threat_density'] = threats.length / 30.0; // per day
    
    return patterns;
  }

  double _calculatePatternConfidence(Map<String, dynamic> patterns) {
    final totalThreats = patterns['threat_count'] ?? 0;
    if (totalThreats < 10) return 0.3;
    if (totalThreats < 50) return 0.6;
    if (totalThreats < 100) return 0.8;
    return 0.95;
  }
}

class NeutralizeThreatUseCase {
  final ThreatRepository repository;

  NeutralizeThreatUseCase({required this.repository});

  Future<Either<String, ThreatModel>> execute({
    required String threatId,
    required String mitigationStrategy,
    Map<String, dynamic> mitigationData = const {},
  }) async {
    try {
      final threat = await repository.getThreatById(threatId);
      
      if (!threat.isActive) {
        return Left('Threat is already neutralized or resolved');
      }
      
      final neutralizedThreat = threat.copyWith(
        status: 'neutralized',
        resolvedAt: DateTime.now(),
        mitigation: mitigationStrategy,
        metadata: {
          ...threat.metadata,
          'neutralized_at': DateTime.now().toIso8601String(),
          'mitigation_data': mitigationData,
          'neutralization_method': 'automated_response',
        },
      );
      
      await repository.updateThreat(neutralizedThreat);
      return Right(neutralizedThreat);
    } catch (e) {
      return Left('Failed to neutralize threat: $e');
    }
  }
}