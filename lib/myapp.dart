import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'pages/home_page.dart';
import 'shared/globals.dart' as globals;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? _canStartApp;

  @override
  void dispose() {
    globals.settingsManager.removeListener(settingsListener);
    super.dispose();
  }

  @override
  void initState() {
    globals.settingsManager.initTheme();
    globals.settingsManager.initLocale();
    globals.settingsManager.addListener(settingsListener);
    super.initState();

    initFutureData().then((value) {
      _canStartApp = true;
      setState(() {});
    });
  }

  void settingsListener() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> initFutureData() async {}

  @override
  Widget build(BuildContext context) {
    FlexScheme usedScheme = FlexScheme.aquaBlue;

    return (_canStartApp == null)
        ? MaterialApp(
            theme: FlexThemeData.light(scheme: usedScheme),
            darkTheme: FlexThemeData.dark(scheme: usedScheme),
            themeMode: ThemeMode.system,
            home: const Scaffold(),
          )
        : MaterialApp(
            navigatorKey: Catcher.navigatorKey,
            onGenerateTitle: (context) {
              return AppLocalizations.of(context)!.appTitle;
            },
            //locale
            localizationsDelegates: const [
              AppLocalizations.delegate,
              // delegate from flutter_localization
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: globals.settingsManager.supportedLocales,
            localeResolutionCallback: (locale, suppLocales) {
              return globals.settingsManager.localeResolution(locale);
            },
            locale: globals.settingsManager.selectedLocale,
            //theme
            theme: FlexThemeData.light(scheme: usedScheme),
            darkTheme: FlexThemeData.dark(scheme: usedScheme),
            themeMode: ThemeMode.system,
            home: const MyHomePage());
  }
}
