class LocalDatasource {
  Future<void> init() async {}
  Future<void> write(String key, String value) async {}
  Future<String?> read(String key) async => null;
}
