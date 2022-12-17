// ignore_for_file: constant_identifier_names

abstract class BaseConfig {
  bool get isItDev;
  bool get isItStaging;
  bool get isItProd;
}

class DevConfig implements BaseConfig {
  @override
  bool get isItDev => true;
  @override
  bool get isItStaging => false;
  @override
  bool get isItProd => false;
}

class StagingConfig implements BaseConfig {
  @override
  bool get isItDev => false;
  @override
  bool get isItStaging => true;
  @override
  bool get isItProd => false;
}

class ProdConfig implements BaseConfig {
  @override
  bool get isItDev => false;
  @override
  bool get isItStaging => false;
  @override
  bool get isItProd => true;
}

class Environment {
  factory Environment() {
    return _singleton;
  }

  Environment._internal();

  static final Environment _singleton = Environment._internal();

  static const String DEV = 'DEV';
  static const String STAGING = 'STAGING';
  static const String PROD = 'PROD';

  BaseConfig config = DevConfig();

  initConfig(String environment) {
    config = _getConfig(environment);
  }

  BaseConfig _getConfig(String environment) {
    switch (environment) {
      case Environment.PROD:
        return ProdConfig();
      case Environment.STAGING:
        return StagingConfig();
      default:
        return DevConfig();
    }
  }
}
