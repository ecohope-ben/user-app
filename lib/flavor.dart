class FlavorConfig {
  final String name;
  final String baseUrl;
  final bool isDebug;
  static FlavorConfig? _instance;

  FlavorConfig._internal({required this.name, required this.baseUrl, this.isDebug = false});

  static void initialize({required String name, required String baseUrl, bool isDebug = false}) {
    _instance = FlavorConfig._internal(name: name, baseUrl: baseUrl, isDebug: isDebug);
  }

  static FlavorConfig get instance => _instance!;
}