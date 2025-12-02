import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cybersentry_ai/services/voice/voice_assistant_service.dart';

class VoiceCommandPage extends StatefulWidget {
  const VoiceCommandPage({super.key});

  @override
  State<VoiceCommandPage> createState() => _VoiceCommandPageState();
}

class _VoiceCommandPageState extends State<VoiceCommandPage> {
  final VoiceAssistantService _voiceService = VoiceAssistantService();
  late Timer _updateTimer;
  String _displayText = 'Ready for voice commands...';
  
  @override
  void initState() {
    super.initState();
    _updateTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _updateTimer.cancel();
    super.dispose();
  }

  void _handleMicrophonePress() async {
    if (!_voiceService.isListening) {
      setState(() {
        _displayText = 'Listening...';
      });
      
      final command = await _voiceService.recognizeSpeech();
      setState(() {
        _displayText = 'Processing: $command';
      });
      
      final response = await _voiceService.processVoiceCommand(command);
      setState(() {
        _displayText = response;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text('Voice Commands'),
        backgroundColor: const Color(0xFF1A1A1A),
      ),
      body: Container(
        color: const Color(0xFF0A0A0A),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Status indicator
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF00FF9D)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text(
                    'Voice Assistant Status',
                    style: TextStyle(color: Color(0xFF00FF9D), fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _voiceService.isListening 
                        ? '🎤 LISTENING...' 
                        : (_voiceService.isSpeaking ? '🔊 SPEAKING...' : '✓ READY'),
                    style: const TextStyle(
                      color: Color(0xFF00FF9D),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Display area
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.cyan),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Last Response',
                      style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          _displayText,
                          style: const TextStyle(color: Colors.cyan, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Microphone button
            GestureDetector(
              onTap: _handleMicrophonePress,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _voiceService.isListening 
                        ? Colors.red 
                        : const Color(0xFF00FF9D),
                    width: 3,
                  ),
                  color: (_voiceService.isListening ? Colors.red : const Color(0xFF00FF9D))
                      .withOpacity(0.1),
                  boxShadow: [
                    BoxShadow(
                      color: _voiceService.isListening 
                          ? Colors.red 
                          : const Color(0xFF00FF9D),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  _voiceService.isListening ? Icons.mic_off : Icons.mic,
                  size: 50,
                  color: _voiceService.isListening 
                      ? Colors.red 
                      : const Color(0xFF00FF9D),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Command history
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Command History',
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                      if (_voiceService.commandHistory.isNotEmpty)
                        GestureDetector(
                          onTap: _voiceService.clearHistory,
                          child: const Text(
                            'Clear',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: _voiceService.commandHistory.isEmpty
                        ? const Text(
                            'No commands yet',
                            style: TextStyle(color: Colors.grey),
                          )
                        : ListView.builder(
                            itemCount: _voiceService.commandHistory.length,
                            itemBuilder: (context, index) {
                              final command = _voiceService.commandHistory[
                                  _voiceService.commandHistory.length - 1 - index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  '> $command',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

