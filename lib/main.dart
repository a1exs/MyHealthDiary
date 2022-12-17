import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:catcher/catcher.dart';
// import 'services/catcher_firebase.dart';

import 'shared/app_vars.dart';
import 'shared/constants.dart';
// import 'services/sqlite_db.dart';
import 'myapp.dart';

void mainDelegate() => appMain();

// ignore: prefer_void_to_null
Future<Null> appMain() async {
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (Environment().config.isItDev) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current
          .handleUncaughtError(details.exception, details.stack as StackTrace);
    }
  };

  // ignore: prefer_void_to_null
  runZonedGuarded<Future<Null>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      //await SqliteDb.init();
      String catcherScreenShots = await myCatcherScreenShotPath();

      final CatcherOptions debugOptions = CatcherOptions(
        PageReportMode(showStackTrace: true),
        [
          // CrashlyticsHandler(
          //   enableDeviceParameters: true,
          //   enableApplicationParameters: true,
          //   enableCustomParameters: true,
          //   printLogs: true
          // ),
          ConsoleHandler(
              enableApplicationParameters: true,
              enableDeviceParameters: true,
              enableCustomParameters: true,
              enableStackTrace: true),
        ],
        screenshotsPath: catcherScreenShots,
      );

      final CatcherOptions releaseOptions = CatcherOptions(DialogReportMode(), [
        EmailManualHandler(
          [
            catcherEmailAddrOne,
            catcherEmailAddrTwo,
          ],
          enableDeviceParameters: true,
          enableStackTrace: true,
          enableCustomParameters: true,
          enableApplicationParameters: true,
          sendHtml: true,
          emailTitle: appName,
          emailHeader: "Error Report",
          printLogs: true,
        ),
      ]);

      final GlobalKey<NavigatorState> navigatorKey =
          GlobalKey<NavigatorState>();
      Catcher(
        rootWidget: const MyApp(),
        debugConfig: debugOptions,
        releaseConfig: releaseOptions,
        navigatorKey: navigatorKey,
      );
    },
    (Object error, StackTrace stack) {},
    zoneSpecification: ZoneSpecification(
      print: (self, parent, zone, line) async {
        final messageToLog = "[${DateTime.now()}] $appName $line $zone";
        parent.print(zone, messageToLog);
      },
    ),
  );
}

Future<String> myCatcherScreenShotPath() async {
  late Directory externalDir;
  if (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia) {
    externalDir = await getExternalStorageDirectory() as Directory;
  }
  if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
    externalDir = await getApplicationDocumentsDirectory();
  }
  String path = externalDir.path.toString();
  return path;
}
