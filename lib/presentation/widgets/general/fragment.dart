import 'package:flutter/material.dart';

import '../../../domain/utils/app.dart';

class AppFragment extends StatelessWidget {
  final String? title;
  final Widget? child;
  final Widget? actions;
  final Widget? trailing;
  final Widget? floatingActionButton;

  final bool isSlided;
  final bool isSlivers;
  final double? topPadding;

  const AppFragment({
    Key? key,
    this.actions,
    this.trailing,
    this.topPadding,
    required this.title,
    required this.child,
    this.floatingActionButton,
    this.isSlivers = false,
    this.isSlided = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return simpleFragment;
  }

  Widget get simpleFragment => SafeArea(
    child: Padding(
      padding: App.appPadding,
      child: Padding(
        padding: App.fragmentPadding,
        child: SizedBox(
          height: double.infinity,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              title!,
                              style: const TextStyle(
                                fontSize: 31,
                                fontWeight: FontWeight.w700
                              ),
                            ),
                          ),
                        ),
                        if(actions != null) actions!
                      ],
                    ),
                    SizedBox(height: topPadding ?? 64),
                    if(!isSlivers)
                    child!
                  ],
                ),
              ),
              if(isSlivers)
              child!
            ],
          )
        ),
      ),
    ),
  );
}
