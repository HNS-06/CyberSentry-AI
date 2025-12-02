import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';

class SystemInfoService with ChangeNotifier {
  final Random _random = Random();
  late Timer _updateTimer;
  
  // System metrics
  double _cpuUsage = 0.0;
  double _memoryUsage = 0.0;
  double _diskUsage = 0.0;
  double _networkUsage = 0.0;
  int _activeProcesses = 0;
  int _threadsActive = 0;
  double _systemTemp = 0.0;
  double _gpuUsage = 0.0;
  
  // Getters
  double get cpuUsage => _cpuUsage;
  double get memoryUsage => _memoryUsage;
  double get diskUsage => _diskUsage;
  double get networkUsage => _networkUsage;
  int get activeProcesses => _activeProcesses;
  int get threadsActive => _threadsActive;
  double get systemTemp => _systemTemp;
  double get gpuUsage => _gpuUsage;
  
  Future<void> initialize() async {
    _startMonitoring();
  }
  
  void _startMonitoring() {
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateSystemMetrics();
      notifyListeners();
    });
  }
  
  void _updateSystemMetrics() {
    // Simulate CPU usage with realistic patterns
    _cpuUsage = (_cpuUsage + (_random.nextDouble() - 0.5) * 15).clamp(5.0, 95.0);
    
    // Simulate Memory usage
    _memoryUsage = (_memoryUsage + (_random.nextDouble() - 0.5) * 10).clamp(10.0, 85.0);
    
    // Simulate Disk usage
    _diskUsage = 45.0 + (_random.nextDouble() - 0.5) * 5;
    
    // Simulate Network usage
    _networkUsage = (_networkUsage + (_random.nextDouble() - 0.5) * 20).clamp(0.0, 100.0);
    
    // Simulate active processes
    _activeProcesses = 45 + _random.nextInt(30);
    
    // Simulate threads
    _threadsActive = 200 + _random.nextInt(150);
    
    // Simulate system temperature
    _systemTemp = (55.0 + (_random.nextDouble() - 0.5) * 15).clamp(40.0, 85.0);
    
    // Simulate GPU usage
    _gpuUsage = (_gpuUsage + (_random.nextDouble() - 0.5) * 12).clamp(0.0, 100.0);
  }
  
  Map<String, dynamic> getSystemStatus() {
    return {
      'cpu_usage': _cpuUsage.toStringAsFixed(1),
      'memory_usage': _memoryUsage.toStringAsFixed(1),
      'disk_usage': _diskUsage.toStringAsFixed(1),
      'network_usage': _networkUsage.toStringAsFixed(1),
      'active_processes': _activeProcesses,
      'threads': _threadsActive,
      'system_temp': _systemTemp.toStringAsFixed(1),
      'gpu_usage': _gpuUsage.toStringAsFixed(1),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
  
  @override
  void dispose() {
    _updateTimer.cancel();
    super.dispose();
  }
}
