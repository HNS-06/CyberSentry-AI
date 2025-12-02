import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cybersentry_ai/app_shell.dart';
import 'package:cybersentry_ai/services/voice/voice_assistant_service.dart';
import 'package:cybersentry_ai/services/monitoring/system_info_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await VoiceAssistantService.init();
  runApp(const CyberSentryMvp());
}

class CyberSentryMvp extends StatefulWidget {
  const CyberSentryMvp({super.key});

  @override
  State<CyberSentryMvp> createState() => _CyberSentryMvpState();
}

class _CyberSentryMvpState extends State<CyberSentryMvp> {
  final VoiceAssistantService _voiceService = VoiceAssistantService();
  final SystemInfoService _systemService = SystemInfoService();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Delay to allow app to render first
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Get system info and announce
    final cpu = _systemService.cpuUsage.toStringAsFixed(1);
    final memory = _systemService.memoryUsage.toStringAsFixed(1);
    final disk = _systemService.diskUsage.toStringAsFixed(1);
    
    final announcement = 'System initialized. Current CPU usage: $cpu percent. Memory usage: $memory percent. Disk usage: $disk percent. CyberSentry AI is now online.';
    
    await _voiceService.speak(announcement);
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'CyberSentry AI (MVP)',
      debugShowCheckedModeBanner: false,
      home: AppShell(),
    );
  }
}