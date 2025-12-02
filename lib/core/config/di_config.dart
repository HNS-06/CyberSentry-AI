import 'package:get_it/get_it.dart';
import 'package:cybersentry_ai/services/ai/neural_firewall_service.dart';
import 'package:cybersentry_ai/services/security/quantum_crypto_service.dart';
import 'package:cybersentry_ai/services/ai/swarm_intelligence_service.dart';
import 'package:cybersentry_ai/services/security/immune_system_service.dart';
import 'package:cybersentry_ai/services/ai/dream_simulation_service.dart';
import 'package:cybersentry_ai/services/security/honeypot_service.dart';
import 'package:cybersentry_ai/services/security/federated_learning_service.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // AI Services
  getIt.registerSingleton<NeuralFirewallService>(NeuralFirewallService());
  getIt.registerSingleton<DreamSimulationService>(DreamSimulationService());
  getIt.registerSingleton<SwarmIntelligenceService>(SwarmIntelligenceService());
  
  // Security Services
  getIt.registerSingleton<QuantumCryptoService>(QuantumCryptoService());
  getIt.registerSingleton<HoneypotService>(HoneypotService());
  getIt.registerSingleton<ImmuneSystemService>(ImmuneSystemService());
  getIt.registerSingleton<FederatedLearningService>(FederatedLearningService());
  
  // Initialize services
  await Future.wait([
    getIt<NeuralFirewallService>().initialize(),
    getIt<QuantumCryptoService>().initialize(),
    getIt<SwarmIntelligenceService>().initializeSwarm(),
    getIt<ImmuneSystemService>().initialize(),
    getIt<DreamSimulationService>().initialize(),
  ]);
}