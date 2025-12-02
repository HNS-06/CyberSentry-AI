import 'package:flutter/material.dart';
import 'package:cybersentry_ai/presentation/pages/main_dashboard.dart';
import 'package:cybersentry_ai/presentation/pages/quantum_vault_page.dart';
import 'package:cybersentry_ai/presentation/pages/threat_intelligence.dart';
import 'package:cybersentry_ai/presentation/pages/cyber_garden_page.dart';
import 'package:cybersentry_ai/presentation/pages/settings_page.dart';
import 'package:cybersentry_ai/presentation/pages/neural_firewall.dart';
import 'package:cybersentry_ai/presentation/pages/digital_immune_page.dart';
import 'package:cybersentry_ai/presentation/pages/honeypot_page.dart';
import 'package:cybersentry_ai/presentation/pages/behavior_biometrics_page.dart';
import 'package:cybersentry_ai/presentation/pages/trust_cluster_page.dart';
import 'package:cybersentry_ai/presentation/pages/dream_journal_page.dart';
import 'package:cybersentry_ai/presentation/pages/holographic_page.dart';
import 'package:cybersentry_ai/presentation/pages/swarm_intelligence_page.dart';
import 'package:cybersentry_ai/presentation/pages/ar_security_page.dart';
import 'package:cybersentry_ai/presentation/pages/voice_command_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final List<String> _pageNames = const [
    'Dashboard',
    'Neural Firewall',
    'Quantum Vault',
    'Threat Intelligence',
    'Cyber Garden',
    'Digital Immune',
    'Honeypot',
    'Behavior & Biometrics',
    'Trust Cluster',
    'Dream Journal',
    'Holographic',
    'Swarm Intelligence',
    'AR Security',
    'Voice Commands',
    'Settings',
  ];

  final List<IconData> _pageIcons = const [
    Icons.dashboard,
    Icons.security,
    Icons.lock,
    Icons.radar,
    Icons.local_florist,
    Icons.favorite,
    Icons.bug_report,
    Icons.fingerprint,
    Icons.group,
    Icons.bedtime,
    Icons.layers,
    Icons.hub,
    Icons.view_in_ar,
    Icons.mic,
    Icons.settings,
  ];

  final List<Widget> _pages = const <Widget>[
    MainDashboard(),
    NeuralFirewallPage(),
    QuantumVaultPage(),
    ThreatIntelligencePage(),
    CyberGardenPage(),
    DigitalImmunePage(),
    HoneypotPage(),
    BehaviorBiometricsPage(),
    TrustClusterPage(),
    DreamJournalPage(),
    HolographicPage(),
    SwarmIntelligencePage(),
    ArSecurityPage(),
    VoiceCommandPage(),
    SettingsPage(),
  ];

  void _onMenuTap(int idx) {
    setState(() => _currentIndex = idx);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageNames[_currentIndex]),
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.cyan,
        elevation: 0,
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF0A0A0A),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF1A1A1A),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.security, color: Colors.cyan, size: 40),
                  SizedBox(height: 12),
                  Text(
                    'CyberSentry AI',
                    style: TextStyle(
                      color: Colors.cyan,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Navigation Menu',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            ...List.generate(
              _pageNames.length,
              (index) => ListTile(
                leading: Icon(
                  _pageIcons[index],
                  color: _currentIndex == index ? Colors.cyan : Colors.grey,
                ),
                title: Text(
                  _pageNames[index],
                  style: TextStyle(
                    color: _currentIndex == index ? Colors.cyan : Colors.white70,
                    fontWeight: _currentIndex == index ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                tileColor: _currentIndex == index ? Colors.cyan.withOpacity(0.1) : null,
                onTap: () => _onMenuTap(index),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(child: _pages[_currentIndex]),
    );
  }
}
