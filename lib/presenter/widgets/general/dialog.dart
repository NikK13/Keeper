import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/utils/app.dart';
import '../../../domain/utils/styles.dart';
import '../../provider/provider.dart';

class AppDialog extends StatelessWidget {
  final String? title;
  final Widget? action;
  final Widget? trailing;
  final Widget? child;
  final bool bottomSafeArea;
  final ScrollController? scrollController;

  const AppDialog({
    Key? key,
    this.action,
    this.trailing,
    required this.title,
    required this.child,
    this.scrollController,
    this.bottomSafeArea = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    return AnnotatedRegion(
      value: App.themedOverlayStyle(provider.currentTheme, context, false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 4),
          SafeArea(
            bottom: false,
            child: Container(
              height: 5,
              width: 35,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light ?
                Colors.white : Colors.grey.shade600,
                borderRadius: BorderRadius.circular(6)
              ),
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
              child: Material(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(24),
                  topLeft: Radius.circular(24)
                ),
                color: dialogBackgroundColor(context),
                child: SafeArea(
                  bottom: bottomSafeArea,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    trailing ?? const SizedBox(width: 40),
                                    Text(
                                      title!,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    action ?? IconButton(
                                      icon: const Icon(
                                        Icons.clear,
                                        size: 24,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }
                                    ),
                                  ],
                                ),
                                child!,
                              ],
                            ),
                          )
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]
      ),
    );
    /*return SafeArea(
      bottom: bottomSafeArea,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: AnnotatedRegion(
          value: App.themedOverlayStyle(prefsProvider.currentTheme, context, false),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16),
              topLeft: Radius.circular(16)
            ),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    children: [
                      dialogLine,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          trailing ?? const SizedBox(width: 40),
                          Text(
                            title!,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          action ?? getIconButton(
                            child: const Icon(
                              Icons.clear,
                              size: 24,
                              color: Colors.grey,
                            ),
                            context: context,
                            onTap: () {
                              Navigator.pop(context);
                            }
                          ),
                        ],
                      ),
                      child!,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );*/
  }
}
