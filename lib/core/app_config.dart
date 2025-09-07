class AppConfig {
  AppConfig._();
  static const String env = String.fromEnvironment("app", defaultValue: "dev");
  static const String fireBaseClientId = String.fromEnvironment(
    "fireBaseClientId",
  );
}