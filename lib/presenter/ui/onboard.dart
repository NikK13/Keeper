// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/utils/app.dart';
import '../../domain/utils/constants.dart';
import '../../domain/utils/localization.dart';
import '../provider/provider.dart';
import '../widgets/animation/show_up.dart';
import '../widgets/general/app_page.dart';
import '../widgets/general/illustrations.dart';
import '../widgets/platform/platform_button.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    return AppPage(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () => provider.switchThemes(),
              borderRadius: BorderRadius.circular(24),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      iconData(provider),
                      color: provider.theme.accentColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      provider.getThemeTitle(context) ?? "",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: ShowUpAnimated(
                delay: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const OnBoardIllustration(),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32
                      ),
                      child: Column(
                        children: [
                           const FittedBox(
                            fit: BoxFit.cover,
                            child: Text(
                              App.appName,
                              style: TextStyle(
                                fontSize: 54,
                                fontWeight: FontWeight.w700
                              ),
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.cover,
                            child: Text(
                              AppLocalizations.of(context, 'desc'),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400
                              ),
                            ),
                          )
                        ],
                      )
                    ),
                  ],
                ),
              ),
            ),
            PlatformButton(
              fontSize: 18,
              text: AppLocalizations.of(context, 'start'),
              onPressed: () async {
                await proceedToApp(context, provider);
              },
            ),
            const SizedBox(height: 32)
          ],
        ),
      ),
    );
  }

  IconData iconData(PreferenceProvider provider){
    final iconsMap = {
      "light": Icons.light_mode_rounded,
      "dark": Icons.dark_mode_outlined,
      "system": Icons.brightness_auto
    };
    return iconsMap.entries.firstWhere((element) =>
    element.key == provider.currentTheme).value;
  }

  Future proceedToApp(BuildContext context, provider) async {
    await provider
      ..savePreference(keyColorIndex, 0)
      ..savePreference(keyIsFirst, false)
      ..savePreference(keyLanguage, provider.locale!.languageCode)
      ..savePreference(key24Hour, PreferenceProvider.is24HourFormatFromLocale(provider.locale!));
  }
}
