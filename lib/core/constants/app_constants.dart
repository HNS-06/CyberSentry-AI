class AppConstants {
  static const String appName = 'CyberSentry AI';
  static const String version = '2.0.1';
  static const String buildId = 'QUANTUM-2024.01';
  
  // Security Levels
  static const List<String> securityLevels = [
    'BASIC',
    'ADVANCED',
    'PARANOID',
    'QUANTUM',
  ];
  
  // Threat Types
  static const List<String> threatTypes = [
    'MALWARE',
    'PHISHING',
    'DDoS',
    'RANSOMWARE',
    'ZERO-DAY',
    'INSIDER',
    'MITM',
    'SQLi',
    'XSS',
    'BOTNET',
  ];
  
  // Neural Network Config
  static const int neuralLayers = 5;
  static const List<int> neuronsPerLayer = [128, 256, 128, 64, 32];
  static const double learningRate = 0.01;
  static const int trainingIterations = 10000;
  
  // Quantum Config
  static const int quantumKeySize = 512;
  static const String quantumAlgorithm = 'LATTICE-BASED';
  static const int timeLockDurationDays = 30;
  
  // Voice Commands
  static const Map<String, List<String>> voiceCommands = {
    'security': [
      'scan for threats',
      'activate firewall',
      'check security status',
      'run vulnerability scan',
      'enable quantum encryption',
    ],
    'analysis': [
      'analyze network traffic',
      'show threat map',
      'display neural network',
      'view security logs',
      'generate report',
    ],
    'tools': [
      'open quantum vault',
      'show honeypot status',
      'start dream simulation',
      'view trust cluster',
      'check immune system',
    ],
    'system': [
      'what can you do',
      'help me',
      'system status',
      'toggle dark mode',
      'exit application',
    ],
  };
  
  // Animation Durations
  static const Duration matrixRainSpeed = Duration(milliseconds: 50);
  static const Duration neuralPulseSpeed = Duration(milliseconds: 500);
  static const Duration hologramRotation = Duration(seconds: 20);
  
  // AR Config
  static const List<String> arModels = [
    'firewall_tower',
    'encryption_sphere',
    'threat_cube',
    'neural_network',
    'quantum_lock',
  ];
  
  // Colors (Hex)
  static const int primaryGreen = 0xFF00FF9D;
  static const int cyberBlue = 0xFF00D1FF;
  static const int quantumPurple = 0xFF7700FF;
  static const int threatRed = 0xFFFF006E;
  static const int warningYellow = 0xFFFFD600;
  
  // API Endpoints (Simulated)
  static const String threatIntelApi = 'https://api.cybersentry.ai/v1/threats';
  static const String quantumKeyExchange = 'https://keys.quantumsecure.ai/exchange';
  static const String federatedLearningHub = 'https://hub.trustcluster.ai/learn';
  
  // Storage Keys
  static const String neuralWeightsKey = 'neural_weights_v2';
  static const String quantumKeysKey = 'quantum_keys_secure';
  static const String threatHistoryKey = 'threat_history_encrypted';
  static const String userProfileKey = 'user_profile_quantum';
  static const String dreamJournalKey = 'dream_journal_ai';
  
  // Limits
  static const int maxThreatHistory = 1000;
  static const int maxDreamEntries = 100;
  static const int maxTrustConnections = 50;
  static const int maxHoneypots = 10;
  
  // Notifications
  static const Duration threatCheckInterval = Duration(minutes: 5);
  static const Duration systemUpdateInterval = Duration(hours: 24);
}