enum Flavor {
  development,
  staging,
  production,
}

class FlavorConfig {
  factory FlavorConfig({
    Flavor? flavor,
    Map<String, dynamic> variables = const {},
  }) {
    _instance = FlavorConfig._internal(
      flavor,
      variables,
    );

    return _instance!;
  }

  FlavorConfig._internal(this.flavor, this.variables);

  final Flavor? flavor;

  final Map<String, dynamic> variables;

  static FlavorConfig? _instance;

  static FlavorConfig get instance {
    _instance ??= FlavorConfig();

    return _instance!;
  }

  bool get isDev => flavor == Flavor.development;

  bool get isStaging => flavor == Flavor.staging;

  bool get isProd => flavor == Flavor.production;
}
