import 'package:flutter/material.dart';
import '../shared/constants.dart' as constants;
import 'local_storage.dart';
import 'package:devicelocale/devicelocale.dart';

class SettingsManager with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _selectedLocale = const Locale("en_US");
  final Iterable<Locale> _supportedLocales = [
    const Locale('en', 'US'),
    const Locale('uk', 'UA'),
    const Locale('ru', 'RU'),
  ];

  ThemeMode get themeMode => _themeMode;
  Locale get selectedLocale => _selectedLocale;
  Iterable<Locale> get supportedLocales => _supportedLocales;

  updateThemeMode(ThemeMode? theme) {
    if (theme == null) return;
    if (theme == _themeMode) return;

    _themeMode = theme;
    int saveThemeMode = 0;
    if (theme == ThemeMode.light) {
      saveThemeMode = 1;
    } else {
      if (theme == ThemeMode.dark) {
        saveThemeMode = 2;
      }
    }
    LocalStorage.saveData(constants.themeMode, saveThemeMode);
    notifyListeners();
  }

  updateLocale(String? language) {
    if (language == null) return;
    Locale newLocale = localeResolution(Locale(language));
    if (newLocale == _selectedLocale) return;

    _selectedLocale = newLocale;
    LocalStorage.saveData(constants.selectedLanguage, language);
    notifyListeners();
  }

  initTheme() async {
    int savedThemeMode = await LocalStorage.readData(constants.themeMode) ?? 0;
    if (savedThemeMode == 1) {
      _themeMode = ThemeMode.light;
    } else if (savedThemeMode == 2) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }
  }

  initLocale() async {
    String language =
        await LocalStorage.readData(constants.selectedLanguage) ?? '';
    if (language == '') {
      language = await Devicelocale.currentLocale ?? 'en';
    }
    Locale selectedLocale = localeResolution(Locale(language));
    _selectedLocale = selectedLocale;
  }

  Locale localeResolution(var locale) {
    if (_supportedLocales.contains(locale)) {
      return locale;
    }
    if (locale?.languageCode == 'uk' || locale?.languageCode == 'uk_UA') {
      return const Locale('uk', 'UA');
    }
    if (locale?.languageCode == 'ru' ||
        locale?.languageCode == 'ru_UA' ||
        locale?.languageCode == 'ru_RU') {
      return const Locale('ru', 'RU');
    }
    return const Locale('en', 'US');
  }
}
