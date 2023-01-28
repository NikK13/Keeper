import 'package:flutter/material.dart';
import 'package:keeper/presenter/bloc/settings_bloc.dart';
import 'package:keeper/presenter/provider/provider.dart';
import 'package:provider/provider.dart';

import '../../domain/utils/constants.dart';
import '../../domain/utils/extensions.dart';
import '../../domain/utils/localization.dart';
import '../widgets/general/dialog.dart';
import '../widgets/platform/platform_button.dart';

class ColorPickerDialog extends StatelessWidget {
  final int selectedIndex;
  final SettingsBloC settingsBloC;

  const ColorPickerDialog({
    Key? key,
    required this.settingsBloC,
    required this.selectedIndex
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    return AppDialog(
      title: AppLocalizations.of(context, 'design_color'),
      child: StreamBuilder(
        stream: settingsBloC.selectedColorStream,
        builder: (context, AsyncSnapshot<int> snapshot) {
          return Column(
            children: [
              const SizedBox(height: 24),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 24
                ),
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.appColors.length,
                itemBuilder: (context, index){
                  return ColorTapItem(
                    index: index,
                    settingsBloC: settingsBloC,
                    color: provider.appColors[index],
                    isColorPicked: snapshot.data == index,
                  );
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: PlatformButton(
                  text: AppLocalizations.of(context, 'choose'),
                  onPressed: () async{
                    Navigator.pop(context);
                    await provider.savePreference(
                      keyColorIndex,
                      snapshot.data
                    );
                  }
                ),
              ),
            ],
          );
        }
      )
    );
  }

  /*void chooseColorIndex(index){
    setState(() => _currentIndex = index);
  }*/
}

class ColorTapItem extends StatelessWidget {
  final int? index;
  final DesignColor? color;
  final SettingsBloC? settingsBloC;
  final bool? isColorPicked;

  const ColorTapItem({
    Key? key,
    this.index,
    this.color,
    this.settingsBloC,
    this.isColorPicked
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: GestureDetector(
        onTap: () => settingsBloC!.changeSelectedColor(index!),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color!.accentColor,
            border: isColorPicked! ?
            Border.all(width: 3, color: accent(context)) :
            null
          ),
        )
      ),
    );
  }
}
