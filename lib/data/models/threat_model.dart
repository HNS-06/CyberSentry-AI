import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThreatModel extends Equatable {
  final String id;
  final String type;
  final String severity;
  final String source;
  final String target;
  final DateTime detectedAt;
  final DateTime? resolvedAt;
  final Map<String, dynamic> metadata;
  final double confidence;
  final List<String> affectedSystems;
  final String status; // 'active', 'neutralized', 'false_positive'
  final String mitigation;
  final int riskScore;

  const ThreatModel({
    required this.id,
    required this.type,
    required this.severity,
    required this.source,
    required this.target,
    required this.detectedAt,
    this.resolvedAt,
    required this.metadata,
    required this.confidence,
    required this.affectedSystems,
    required this.status,
    required this.mitigation,
    required this.riskScore,
  });

  factory ThreatModel.fromJson(Map<String, dynamic> json) {
    return ThreatModel(
      id: json['id'] ?? '',
      type: json['type'] ?? 'UNKNOWN',
      severity: json['severity'] ?? 'MEDIUM',
      source: json['source'] ?? 'Unknown',
      target: json['target'] ?? 'Unknown',
      detectedAt: DateTime.parse(json['detected_at']),
      resolvedAt: json['resolved_at'] != null 
          ? DateTime.parse(json['resolved_at'])
          : null,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      affectedSystems: List<String>.from(json['affected_systems'] ?? []),
      status: json['status'] ?? 'active',
      mitigation: json['mitigation'] ?? 'Investigation pending',
      riskScore: json['risk_score'] ?? 50,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'severity': severity,
      'source': source,
      'target': target,
      'detected_at': detectedAt.toIso8601String(),
      'resolved_at': resolvedAt?.toIso8601String(),
      'metadata': metadata,
      'confidence': confidence,
      'affected_systems': affectedSystems,
      'status': status,
      'mitigation': mitigation,
      'risk_score': riskScore,
    };
  }

  ThreatModel copyWith({
    String? id,
    String? type,
    String? severity,
    String? source,
    String? target,
    DateTime? detectedAt,
    DateTime? resolvedAt,
    Map<String, dynamic>? metadata,
    double? confidence,
    List<String>? affectedSystems,
    String? status,
    String? mitigation,
    int? riskScore,
  }) {
    return ThreatModel(
      id: id ?? this.id,
      type: type ?? this.type,
      severity: severity ?? this.severity,
      source: source ?? this.source,
      target: target ?? this.target,
      detectedAt: detectedAt ?? this.detectedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      metadata: metadata ?? this.metadata,
      confidence: confidence ?? this.confidence,
      affectedSystems: affectedSystems ?? this.affectedSystems,
      status: status ?? this.status,
      mitigation: mitigation ?? this.mitigation,
      riskScore: riskScore ?? this.riskScore,
    );
  }

  bool get isActive => status == 'active';
  bool get isNeutralized => status == 'neutralized';
  bool get isCritical => severity == 'CRITICAL';
  
  Color get severityColor {
    switch (severity) {
      case 'CRITICAL':
        return const Color(0xFFFF006E);
      case 'HIGH':
        return const Color(0xFFFF5252);
      case 'MEDIUM':
        return const Color(0xFFFFD600);
      case 'LOW':
        return const Color(0xFF00D1FF);
      default:
        return Colors.grey;
    }
  }

  @override
  List<Object?> get props => [
    id,
    type,
    severity,
    source,
    target,
    detectedAt,
    resolvedAt,
    metadata,
    confidence,
    affectedSystems,
    status,
    mitigation,
    riskScore,
  ];
}

class ThreatHistory {
  final List<ThreatModel> threats;
  final DateTime startDate;
  final DateTime endDate;
  final Statistics statistics;

  const ThreatHistory({
    required this.threats,
    required this.startDate,
    required this.endDate,
    required this.statistics,
  });

  factory ThreatHistory.empty() {
    return ThreatHistory(
      threats: [],
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      statistics: Statistics.empty(),
    );
  }
}

class Statistics {
  final int totalThreats;
  final int activeThreats;
  final int neutralizedThreats;
  final int falsePositives;
  final Map<String, int> threatsByType;
  final Map<String, int> threatsBySeverity;
  final double averageResponseTime; // in minutes
  final double threatDetectionRate; // threats per hour

  const Statistics({
    required this.totalThreats,
    required this.activeThreats,
    required this.neutralizedThreats,
    required this.falsePositives,
    required this.threatsByType,
    required this.threatsBySeverity,
    required this.averageResponseTime,
    required this.threatDetectionRate,
  });

  factory Statistics.empty() {
    return Statistics(
      totalThreats: 0,
      activeThreats: 0,
      neutralizedThreats: 0,
      falsePositives: 0,
      threatsByType: {},
      threatsBySeverity: {},
      averageResponseTime: 0.0,
      threatDetectionRate: 0.0,
    );
  }

  factory Statistics.fromThreats(List<ThreatModel> threats) {
    final now = DateTime.now();
    final last24Hours = threats.where((t) => 
      t.detectedAt.isAfter(now.subtract(const Duration(hours: 24)))
    ).toList();

    final threatsByType = <String, int>{};
    final threatsBySeverity = <String, int>{};

    for (final threat in threats) {
      threatsByType[threat.type] = (threatsByType[threat.type] ?? 0) + 1;
      threatsBySeverity[threat.severity] = 
          (threatsBySeverity[threat.severity] ?? 0) + 1;
    }

    final neutralized = threats.where((t) => t.isNeutralized).toList();
    final responseTimes = neutralized
        .where((t) => t.resolvedAt != null)
        .map((t) => t.resolvedAt!.difference(t.detectedAt).inMinutes)
        .toList();

    final avgResponseTime = responseTimes.isEmpty
        ? 0.0
        : responseTimes.reduce((a, b) => a + b) / responseTimes.length;

    return Statistics(
      totalThreats: threats.length,
      activeThreats: threats.where((t) => t.isActive).length,
      neutralizedThreats: neutralized.length,
      falsePositives: threats.where((t) => t.status == 'false_positive').length,
      threatsByType: threatsByType,
      threatsBySeverity: threatsBySeverity,
      averageResponseTime: avgResponseTime,
      threatDetectionRate: last24Hours.length / 24.0,
    );
  }
}