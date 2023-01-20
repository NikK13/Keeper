import 'package:flutter/material.dart';
import 'package:keeper/data/db/db/db.dart';
import 'package:keeper/data/navigator/delegate.dart';
import 'package:keeper/data/navigator/parser.dart';
import 'package:provider/provider.dart';

import 'domain/utils/app.dart';
import 'domain/utils/localization.dart';
import 'domain/utils/styles.dart';
import 'presenter/provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await AppLocalizations.loadLanguages();
  await DatabaseProvider.initDatabase();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PreferenceProvider()),
      ],
      child: Application(),
    ),
  );
}

class Application extends StatelessWidget{
  final _routerParser = AppRouterParser();
  final _routerDelegate = AppRouterDelegate();
  final _backDispatcher = RootBackButtonDispatcher();

  Application({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferenceProvider>(
      builder: (ctx, prefsProvider, child) {
        return prefsProvider.isFirst != null ? MaterialApp.router(
          debugShowCheckedModeBanner: false,
          showPerformanceOverlay: false,
          locale: prefsProvider.preferences.locale,
          localizationsDelegates: App.delegates,
          supportedLocales: App.supportedLocales,
          themeMode: getThemeMode(prefsProvider.currentTheme ?? "system"),
          theme: themeLight, darkTheme: themeDark,
          routerDelegate: _routerDelegate,
          routeInformationParser: _routerParser,
          backButtonDispatcher: _backDispatcher,
        ) : const SizedBox();
      },
    );
  }
}
