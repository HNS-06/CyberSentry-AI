import 'package:cybersentry_ai/data/models/neural_model.dart';

class NeuralRepository {
  Future<NeuralModel> loadModel(String id) async {
    return NeuralModel(id: id, weights: {});
  }
}
