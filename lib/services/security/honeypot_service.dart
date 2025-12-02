import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HoneypotService with ChangeNotifier {
  final List<Honeypot> _honeypots = [];
  final List<AttackLog> _attackLogs = [];
  final Random _random = Random();
  Timer? _attackSimulationTimer;
  
  List<Honeypot> get honeypots => _honeypots;
  List<AttackLog> get attackLogs => _attackLogs;
  int get totalTrapsSprung => _attackLogs.length;
  
  Future<void> initialize() async {
    // Initialize default honeypots
    _initializeDefaultHoneypots();
    
    // Load previous attack logs
    await _loadAttackLogs();
    
    // Start attack simulation
    _startAttackSimulation();
    
    notifyListeners();
  }
  
  void _initializeDefaultHoneypots() {
    _honeypots.addAll([
      Honeypot(
        id: 'hp_ssh',
        name: 'SSH Server',
        type: HoneypotType.server,
        description: 'Fake SSH server with weak credentials',
        ipAddress: '192.168.1.100',
        port: 22,
        isActive: true,
        trapCount: 0,
        created: DateTime.now().subtract(const Duration(days: 7)),
        baitData: 'root:password123',
        deceptionLevel: 0.8,
      ),
      Honeypot(
        id: 'hp_web',
        name: 'Web Admin Portal',
        type: HoneypotType.web,
        description: 'Fake administration portal with vulnerabilities',
        ipAddress: '192.168.1.101',
        port: 80,
        isActive: true,
        trapCount: 0,
        created: DateTime.now().subtract(const Duration(days: 5)),
        baitData: 'admin:admin',
        deceptionLevel: 0.9,
      ),
      Honeypot(
        id: 'hp_db',
        name: 'Database Server',
        type: HoneypotType.database,
        description: 'Fake MySQL database with exposed credentials',
        ipAddress: '192.168.1.102',
        port: 3306,
        isActive: true,
        trapCount: 0,
        created: DateTime.now().subtract(const Duration(days: 3)),
        baitData: 'mysql_user:weakpass',
        deceptionLevel: 0.7,
      ),
      Honeypot(
        id: 'hp_api',
        name: 'REST API',
        type: HoneypotType.api,
        description: 'Fake API with security flaws',
        ipAddress: '192.168.1.103',
        port: 8080,
        isActive: true,
        trapCount: 0,
        created: DateTime.now().subtract(const Duration(days: 1)),
        baitData: 'api_key:test_key_123',
        deceptionLevel: 0.85,
      ),
    ]);
  }
  
  Future<void> _loadAttackLogs() async {
    // Simulate loading from storage
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Add some example logs
    _attackLogs.addAll([
      AttackLog(
        id: 'log_1',
        honeypotId: 'hp_ssh',
        attackerIp: '10.0.0.15',
        timestamp: DateTime.now().subtract(const Duration(hours: 48)),
        attackType: 'Brute Force',
        credentialsTried: ['root:admin', 'root:password', 'admin:admin'],
        payload: 'SSH connection attempt',
        capturedData: {
          'username': 'root',
          'password': 'password123',
          'client_version': 'OpenSSH_8.2p1',
        },
        threatLevel: 0.7,
      ),
      AttackLog(
        id: 'log_2',
        honeypotId: 'hp_web',
        attackerIp: '172.16.0.23',
        timestamp: DateTime.now().subtract(const Duration(hours: 24)),
        attackType: 'SQL Injection',
        credentialsTried: ['admin:admin', 'admin:password'],
        payload: "' OR '1'='1",
        capturedData: {
          'user_agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
          'injection_attempt': true,
          'parameters': {'username': "' OR '1'='1"},
        },
        threatLevel: 0.9,
      ),
    ]);
  }
  
  void _startAttackSimulation() {
    _attackSimulationTimer = Timer.periodic(
      const Duration(minutes: 2),
      (_) => _simulateAttack(),
    );
  }
  
  Future<void> _simulateAttack() async {
    if (_honeypots.isEmpty || !_anyActiveHoneypots()) return;
    
    // Randomly select a honeypot
    final activeHoneypots = _honeypots.where((hp) => hp.isActive).toList();
    if (activeHoneypots.isEmpty) return;
    
    final honeypot = activeHoneypots[_random.nextInt(activeHoneypots.length)];
    
    // Generate attack
    final attack = _generateAttack(honeypot);
    
    // Log the attack
    _attackLogs.insert(0, attack);
    
    // Update honeypot trap count
    final index = _honeypots.indexWhere((hp) => hp.id == honeypot.id);
    if (index != -1) {
      _honeypots[index] = honeypot.copyWith(
        trapCount: honeypot.trapCount + 1,
        lastAttack: DateTime.now(),
      );
    }
    
    // Limit logs
    if (_attackLogs.length > 100) {
      _attackLogs.removeLast();
    }
    
    notifyListeners();
  }
  
  AttackLog _generateAttack(Honeypot honeypot) {
    final attackTypes = [
      'Brute Force',
      'SQL Injection',
      'XSS',
      'Command Injection',
      'Credential Stuffing',
      'Port Scanning',
      'Directory Traversal',
    ];
    
    final attackerIps = [
      '10.0.${_random.nextInt(255)}.${_random.nextInt(255)}',
      '172.16.${_random.nextInt(255)}.${_random.nextInt(255)}',
      '192.168.${_random.nextInt(255)}.${_random.nextInt(255)}',
      '203.0.${_random.nextInt(255)}.${_random.nextInt(255)}',
    ];
    
    final credentials = [
      'admin:admin',
      'root:password',
      'user:123456',
      'administrator:admin123',
      'test:test',
    ];
    
    final attackType = attackTypes[_random.nextInt(attackTypes.length)];
    final threatLevel = 0.5 + _random.nextDouble() * 0.5;
    
    return AttackLog(
      id: 'log_${DateTime.now().millisecondsSinceEpoch}',
      honeypotId: honeypot.id,
      attackerIp: attackerIps[_random.nextInt(attackerIps.length)],
      timestamp: DateTime.now(),
      attackType: attackType,
      credentialsTried: [
        credentials[_random.nextInt(credentials.length)],
        if (_random.nextDouble() > 0.5) credentials[_random.nextInt(credentials.length)],
      ],
      payload: _generatePayload(attackType, honeypot.type),
      capturedData: _generateCapturedData(attackType, honeypot.type),
      threatLevel: threatLevel,
    );
  }
  
  String _generatePayload(String attackType, HoneypotType honeypotType) {
    switch (attackType) {
      case 'SQL Injection':
        return "' OR '1'='1' --";
      case 'XSS':
        return '<script>alert("XSS")</script>';
      case 'Command Injection':
        return '; ls -la;';
      case 'Directory Traversal':
        return '../../../etc/passwd';
      default:
        return 'Attack attempt';
    }
  }
  
  Map<String, dynamic> _generateCapturedData(String attackType, HoneypotType honeypotType) {
    final data = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'attack_type': attackType,
      'honeypot_type': honeypotType.name,
      'simulated': true,
    };
    
    if (_random.nextDouble() > 0.5) {
      data['user_agent'] = _generateUserAgent();
    }
    
    if (_random.nextDouble() > 0.7) {
      data['geolocation'] = _generateGeolocation();
    }
    
    if (_random.nextDouble() > 0.8) {
      data['attack_tools'] = _generateAttackTools();
    }
    
    return data;
  }
  
  String _generateUserAgent() {
    const userAgents = [
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15',
      'curl/7.68.0',
      'python-requests/2.25.1',
      'nmap/7.80',
    ];
    
    return userAgents[_random.nextInt(userAgents.length)];
  }
  
  Map<String, dynamic> _generateGeolocation() {
    const countries = ['US', 'CN', 'RU', 'DE', 'FR', 'JP', 'BR'];
    const cities = ['New York', 'Beijing', 'Moscow', 'Berlin', 'Paris', 'Tokyo', 'Sao Paulo'];
    
    final index = _random.nextInt(countries.length);
    
    return {
      'country': countries[index],
      'city': cities[index],
      'latitude': 20 + _random.nextDouble() * 50,
      'longitude': -120 + _random.nextDouble() * 240,
    };
  }
  
  List<String> _generateAttackTools() {
    const tools = [
      'Metasploit',
      'Nmap',
      'Burp Suite',
      'SQLmap',
      'John the Ripper',
      'Hydra',
      'Aircrack-ng',
    ];
    
    final selectedTools = <String>[];
    for (final tool in tools) {
      if (_random.nextDouble() > 0.7) {
        selectedTools.add(tool);
      }
    }
    
    return selectedTools.isEmpty ? [tools[_random.nextInt(tools.length)]] : selectedTools;
  }
  
  bool _anyActiveHoneypots() {
    return _honeypots.any((hp) => hp.isActive);
  }
  
  Future<Honeypot> createHoneypot({
    required String name,
    required HoneypotType type,
    required String description,
    required String ipAddress,
    required int port,
    String baitData = '',
    double deceptionLevel = 0.7,
  }) async {
    final honeypot = Honeypot(
      id: 'hp_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      type: type,
      description: description,
      ipAddress: ipAddress,
      port: port,
      isActive: true,
      trapCount: 0,
      created: DateTime.now(),
      baitData: baitData,
      deceptionLevel: deceptionLevel.clamp(0.0, 1.0),
    );
    
    _honeypots.add(honeypot);
    notifyListeners();
    
    return honeypot;
  }
  
  Future<void> toggleHoneypot(String id) async {
    final index = _honeypots.indexWhere((hp) => hp.id == id);
    if (index != -1) {
      _honeypots[index] = _honeypots[index].copyWith(
        isActive: !_honeypots[index].isActive,
      );
      notifyListeners();
    }
  }
  
  Future<void> deleteHoneypot(String id) async {
    _honeypots.removeWhere((hp) => hp.id == id);
    notifyListeners();
  }
  
  Future<void> analyzeAttackPatterns() async {
    // Simulate analysis
    await Future.delayed(const Duration(seconds: 2));
    
    // In real implementation, this would analyze attack logs
    // and provide insights
  }
  
  Map<String, dynamic> getHoneypotStatistics() {
    final activeHoneypots = _honeypots.where((hp) => hp.isActive).length;
    final totalTraps = _honeypots.fold<int>(0, (sum, hp) => sum + hp.trapCount);
    final attackLogsCount = _attackLogs.length;
    
    final attacksByType = <String, int>{};
    for (final log in _attackLogs) {
      attacksByType[log.attackType] = (attacksByType[log.attackType] ?? 0) + 1;
    }
    
    final attacksByHoneypot = <String, int>{};
    for (final log in _attackLogs) {
      attacksByHoneypot[log.honeypotId] = 
          (attacksByHoneypot[log.honeypotId] ?? 0) + 1;
    }
    
    final avgThreatLevel = _attackLogs.isEmpty
        ? 0.0
        : _attackLogs.map((log) => log.threatLevel)
                     .reduce((a, b) => a + b) / _attackLogs.length;
    
    return {
      'active_honeypots': activeHoneypots,
      'total_honeypots': _honeypots.length,
      'total_traps_sprung': totalTraps,
      'total_attack_logs': attackLogsCount,
      'attacks_by_type': attacksByType,
      'attacks_by_honeypot': attacksByHoneypot,
      'average_threat_level': avgThreatLevel,
      'last_attack': _attackLogs.isNotEmpty ? _attackLogs.first.timestamp : null,
      'most_targeted_honeypot': _getMostTargetedHoneypot(),
    };
  }
  
  String? _getMostTargetedHoneypot() {
    if (_attackLogs.isEmpty) return null;
    
    final counts = <String, int>{};
    for (final log in _attackLogs) {
      counts[log.honeypotId] = (counts[log.honeypotId] ?? 0) + 1;
    }
    
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sorted.isNotEmpty ? sorted.first.key : null;
  }
  
  Future<List<AttackLog>> getRecentAttacks({int limit = 10}) async {
    return _attackLogs.take(limit).toList();
  }
  
  @override
  void dispose() {
    _attackSimulationTimer?.cancel();
    super.dispose();
  }
}

enum HoneypotType {
  server,
  web,
  database,
  api,
  file,
  network,
}

class Honeypot {
  final String id;
  final String name;
  final HoneypotType type;
  final String description;
  final String ipAddress;
  final int port;
  final bool isActive;
  final int trapCount;
  final DateTime created;
  final DateTime? lastAttack;
  final String baitData;
  final double deceptionLevel; // 0.0 to 1.0
  
  Honeypot({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.ipAddress,
    required this.port,
    required this.isActive,
    required this.trapCount,
    required this.created,
    this.lastAttack,
    required this.baitData,
    required this.deceptionLevel,
  });
  
  Honeypot copyWith({
    String? id,
    String? name,
    HoneypotType? type,
    String? description,
    String? ipAddress,
    int? port,
    bool? isActive,
    int? trapCount,
    DateTime? created,
    DateTime? lastAttack,
    String? baitData,
    double? deceptionLevel,
  }) {
    return Honeypot(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      ipAddress: ipAddress ?? this.ipAddress,
      port: port ?? this.port,
      isActive: isActive ?? this.isActive,
      trapCount: trapCount ?? this.trapCount,
      created: created ?? this.created,
      lastAttack: lastAttack ?? this.lastAttack,
      baitData: baitData ?? this.baitData,
      deceptionLevel: deceptionLevel ?? this.deceptionLevel,
    );
  }
  
  String get status => isActive ? 'ACTIVE' : 'INACTIVE';
  Color get statusColor => isActive ? Colors.green : Colors.grey;
  
  String get typeString {
    switch (type) {
      case HoneypotType.server:
        return 'Server';
      case HoneypotType.web:
        return 'Web';
      case HoneypotType.database:
        return 'Database';
      case HoneypotType.api:
        return 'API';
      case HoneypotType.file:
        return 'File';
      case HoneypotType.network:
        return 'Network';
    }
  }
}

class AttackLog {
  final String id;
  final String honeypotId;
  final String attackerIp;
  final DateTime timestamp;
  final String attackType;
  final List<String> credentialsTried;
  final String payload;
  final Map<String, dynamic> capturedData;
  final double threatLevel; // 0.0 to 1.0
  
  AttackLog({
    required this.id,
    required this.honeypotId,
    required this.attackerIp,
    required this.timestamp,
    required this.attackType,
    required this.credentialsTried,
    required this.payload,
    required this.capturedData,
    required this.threatLevel,
  });
  
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
  
  Color get threatColor {
    if (threatLevel > 0.8) return Colors.red;
    if (threatLevel > 0.6) return Colors.orange;
    if (threatLevel > 0.4) return Colors.yellow;
    return Colors.green;
  }
}