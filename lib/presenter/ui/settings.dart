// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keeper/presenter/widgets/general/loading.dart';
import 'package:provider/provider.dart';

import '../../data/api/repository.dart';
import '../../domain/utils/app.dart';
import '../../domain/utils/constants.dart';
import '../../domain/utils/extensions.dart';
import '../../domain/utils/lists.dart';
import '../../domain/utils/localization.dart';
import '../../domain/utils/styles.dart';
import '../../domain/utils/versions.dart';
import '../provider/provider.dart';
import '../widgets/general/app_page.dart';
import '../widgets/general/dialog.dart';
import '../widgets/general/dialogs.dart';
import '../widgets/general/settings_ui.dart';
import '../widgets/general/switch.dart';
import '../widgets/platform/platform_appbar.dart';
import '../widgets/platform/platform_button.dart';

class SettingsPage extends StatelessWidget {

  const SettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    return AppPage(
      bottomSafeArea: false,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      appBar: !kIsWeb ? PlatformAppBar(
        title: AppLocalizations.of(context, 'settings'),
      ) : null,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            SettingsSection(
              title: AppLocalizations.of(context, 'common'),
              settingsItems: [
                SettingsRow(
                  title: AppLocalizations.of(context, 'change_lang'),
                  onTap: () => !isIosApplication ? showSelectionDialog(
                    context, languages,
                    "language", provider, 'change_lang'
                  ) : showIosSelectionDialog(
                    context, languages,
                    "language", provider,
                    provider.locale!.languageCode
                  ),
                  trailing: languages.firstWhere((element) => element.value == provider.locale!.languageCode).title,
                  icon: Icons.language_rounded,
                  isFirst: true,
                  isLast: false,
                ),
                SettingsRow(
                  title: AppLocalizations.of(context, 'hours24format'),
                  onTap: () => changeHourFormat(provider),
                  icon: CupertinoIcons.clock,
                  switchData: CustomSwitch(
                    value: provider.is24HourFormat!,
                    enableColor: provider.theme.accentColor,
                    onChanged: (val) => changeHourFormat(provider)
                  ),
                  isFirst: false,
                  isLast: true,
                ),
              ]
            ),
            SettingsSection(
              title: AppLocalizations.of(context, 'appearance'),
              settingsItems: [
                SettingsRow(
                  title: AppLocalizations.of(context, 'current_theme'),
                  onTap: () => !isIosApplication ? showSelectionDialog(
                    context, listOfThemes(context),
                    "theme", provider, 'current_theme'
                  ) : showIosSelectionDialog(
                    context, listOfThemes(context),
                    "theme", provider,
                    provider.currentTheme!
                  ),
                  trailing: provider.getThemeTitle(context),
                  icon: Icons.brightness_auto,
                  isFirst: true,
                  isLast: true,
                ),
                /*SettingsRow(
                  title: AppLocalizations.of(context, 'design_color'),
                  onTap: () => showContentDialog(context, ColorPickerDialog(
                    selectedIndex: provider.currentColorIndex!,
                    colorsBloc: ColorsBloc(provider.currentColorIndex!),
                  )),
                  icon: Icons.palette_outlined,
                  isFirst: false,
                  isLast: true,
                  switchData: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: provider.appColors
                      [provider.currentColorIndex!].accentColor
                    ),
                  ),
                ),*/
              ]
            ),
            SettingsSection(
              title: AppLocalizations.of(context, 'app'),
              settingsItems: [
                SettingsRow(
                  title: App.appName,
                  onTap: () => showContentDialog(
                    context, aboutInfo(context, 0, provider)
                  ),
                  trailing: provider.packageInfo!.version,
                  icon: Icons.help_outline,
                  isFirst: true,
                  isLast: false,
                ),
                SettingsRow(
                  title: AppLocalizations.of(context, 'check_update'),
                  onTap: (){
                    showContentDialog(
                      context, updateInfo(context, provider, checkUpdate(provider))
                    );
                  },
                  trailing: isIosApplication ?
                  "" : null,
                  icon: Icons.downloading,
                  isFirst: false,
                  isLast: true,
                ),
              ]
            )
          ],
        ),
      ),
    );
  }

  Future<bool> checkUpdate(PreferenceProvider provider) async{
    final app = await APIRepository.fetchApplicationData();
    if(app != null){
      final appVersion = (defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android
      ? (defaultTargetPlatform == TargetPlatform.iOS ?
      app.iosVer! : app.androidVer!) : null);
      if(appVersion != null){
        final serverVersion = AppVC.parse(appVersion.version!);
        final currentVersion = AppVC.parse(provider.packageInfo!.version);
        return serverVersion.isHigherThanNow(currentVersion);
      }
      else{
        return false;
      }
    }
    else {
      return false;
    }
  }

  Widget aboutInfo(BuildContext context, counter, provider) => AppDialog(
    title: AppLocalizations.of(context, 'about_app'),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        Icon(
          Icons.sticky_note_2_outlined,
          size: 150,
          color: provider.theme.accentColor,
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            if(counter < 4) {
              counter++;
            } else{
              Navigator.pop(context);
              provider.changeOsUI();
            }
          },
          child: Text(
            "${App.appName}, ${provider.packageInfo!.version}",
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 28
            ),
          ),
        ),
        const Text(
          "2023 ®NikK13\nAll rights reserved.",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => showLicensePage(context: context),
          style: TextButton.styleFrom(
            foregroundColor: provider.theme.accentColor,
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              fontFamily: appFont
            )
          ),
          child: Text(AppLocalizations.of(context, 'os_libraries'))
        ),
      ]
    )
  );

  Widget updateInfo(BuildContext context, provider, loadUpdateInfo) => AppDialog(
    title: AppLocalizations.of(context, 'app'),
    child: SizedBox(
      height: MediaQuery.of(context).size.height * 0.455,
      child: FutureBuilder(
        future: loadUpdateInfo,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          return snapshot.hasData ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Icon(
                snapshot.data! ?
                Icons.downloading_rounded :
                Icons.check_circle_outline,
                size: 150,
                color: snapshot.data! ?
                const Color(0xFF21C51F) :
                provider.theme.accentColor,
              ),
              const SizedBox(height: 16),
              Text(
                snapshot.data! ?
                AppLocalizations.of(context, 'app_update_yes') :
                AppLocalizations.of(context, 'app_update_no'),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              PlatformButton(
                text: snapshot.data! ?
                AppLocalizations.of(context, 'update') :
                AppLocalizations.of(context, 'well'),
                onPressed: (){
                  Navigator.pop(context);
                }
              ),
            ]
          ) : const LoadingView();
        }
      ),
    )
  );

  void changeHourFormat(PreferenceProvider provider){
    provider.is24HourFormat = !provider.is24HourFormat!;
    provider.savePreference(key24Hour, provider.is24HourFormat);
  }

  showIosSelectionDialog(context, List<ListItem> items, type, provider, val){
    dynamic value;
    showCupertinoModalPopup(context: context, builder: (context){
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: App.themedOverlayStyle(provider.currentTheme, context, false),
        child: CupertinoActionSheet(
          actions: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: NotificationListener<ScrollEndNotification>(
                onNotification: (notification){
                  if (notification.metrics is! FixedExtentMetrics) {
                    return false;
                  }
                  final index = (notification.metrics as FixedExtentMetrics).itemIndex;
                  value = items[index].value;
                  return false;
                },
                child: CupertinoPicker(
                  magnification: 1.5,
                  backgroundColor: Theme.of(context).brightness == Brightness.light ?
                  Colors.white : const Color(0xFF181818),
                  itemExtent: 40,
                  onSelectedItemChanged: null, //h
                  scrollController: FixedExtentScrollController(initialItem: items.indexWhere((element) => element.value == val)),// eight of each item
                  children: List.generate(items.length, (index) => items[index]).map((item) => Center(
                    child: Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: appFont,
                        color: accent(context),
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  )).toList(),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ?
                const Color(0xFF181818) : Colors.white,
                borderRadius: BorderRadius.circular(10)
              ),
              child: CupertinoActionSheetAction(
                child: Text(
                  AppLocalizations.of(context, 'choose'),
                  style: TextStyle(
                    fontFamily: appFont,
                    color: provider.theme.accentColor,
                    fontWeight: FontWeight.w600
                  ),
                ),
                onPressed: (){
                  if(type == "theme"){
                    provider.savePreference(keyThemeMode, value);
                  }
                  if(type == "language"){
                    provider.savePreference(keyLanguage, value);
                  }
                  Navigator.pop(context);
                },
              ),
            ),
          ],
          cancelButton: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ?
              const Color(0xFF181818) : Colors.white,
              borderRadius: BorderRadius.circular(10)
            ),
            child: CupertinoActionSheetAction(
              child: Text(
                AppLocalizations.of(context, 'cancel'),
                style: const TextStyle(
                  fontFamily: appFont,
                  color: Colors.red,
                  fontWeight: FontWeight.w600
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      );
    });
  }

  showSelectionDialog(context, List<ListItem> list, type, provider, key){
    showContentDialog(context, AppDialog(
      title: AppLocalizations.of(context, key),
      bottomSafeArea: false,
      child: Column(
        children: [
          const SizedBox(height: 12),
          ListView.builder(
            itemCount: list.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
              final item = list[index];
              return GestureDetector(
                onTap: (){
                  if(type == "theme"){
                    provider.savePreference(keyThemeMode, item.value);
                  }
                  if(type == "language"){
                    provider.savePreference(keyLanguage, item.value);
                  }
                  Navigator.of(context).pop();
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 4
                  ),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Center(
                      child: Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).brightness == Brightness.light ?
                          Colors.black : Colors.white,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ), false , 0.925);
  }
}
