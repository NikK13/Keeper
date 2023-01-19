import 'dart:async';

import 'package:flutter/material.dart';
import 'package:keeper/presenter/widgets/slivers/sliver_header.dart';

import '../../../domain/utils/styles.dart';

class CustomSliverBar extends StatefulWidget {
  final Widget? sliverHeader;
  final Widget? child;
  final String? title;
  final Widget? actions;
  final Widget? trailing;
  final double topPadding;
  final String? collapsedTitle;
  final double collapsedTextSize;
  final Function? onUserScroll;

  const CustomSliverBar({
    super.key,
    this.sliverHeader,
    this.title,
    this.child, this.actions,
    this.topPadding = 64,
    this.collapsedTextSize = 30,
    this.collapsedTitle,
    this.onUserScroll,
    this.trailing,
  });

  @override
  State<CustomSliverBar> createState() => _CustomSliverBarState();
}

class _CustomSliverBarState extends State<CustomSliverBar> {
  final _controller = ScrollController();

  double get maxHeight => 170 + MediaQuery.of(context).padding.top;
  double get minHeight => kToolbarHeight + MediaQuery.of(context).padding.top;

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (scrollNotification) {
        if(scrollNotification is ScrollEndNotification && scrollNotification.depth == 0){
          _snapAppbar();
        }
        if(scrollNotification is UserScrollNotification && widget.onUserScroll != null){
          widget.onUserScroll!(scrollNotification);
        }
        return false;
      },
      child: NestedScrollView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled){
          return [
            SliverAppBar(
              elevation: 0,
              pinned: true,
              flexibleSpace: _Header(
                maxHeight: maxHeight,
                minHeight: minHeight,
                title: widget.title!,
                collapsedTitle: widget.collapsedTitle ?? "",
                collapsedTextSize: widget.collapsedTextSize,
              ),
              automaticallyImplyLeading: false,
              scrolledUnderElevation: 0,
              actions: widget.actions != null ?
              [widget.actions!] : null,
              leading: widget.trailing,
              backgroundColor: backgroundColor(context),
              expandedHeight: maxHeight - MediaQuery.of(context).padding.top,
            ),
            if(widget.sliverHeader != null)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(8, 72, 8, 0),
              sliver: AppSliverHeader(child: widget.sliverHeader!)
            )
          ];
        },
        body: Padding(
          padding: EdgeInsets.only(top: widget.topPadding, left: 8, right: 8),
          child: widget.child!,
        )
      ),
    );
  }

  void _snapAppbar() {
    final scrollDistance = maxHeight - minHeight;
    if (_controller.offset > 0 && _controller.offset < scrollDistance) {
      final double snapOffset = _controller.offset / scrollDistance > 0.55 ? scrollDistance : 0;
      Timer(const Duration(milliseconds: 1), () => _controller.animateTo(
          snapOffset,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeIn
      ));
    }
  }
}

class _Header extends StatelessWidget {
  final double? maxHeight;
  final double? minHeight;
  final String title;
  final double collapsedTextSize;
  final String collapsedTitle;

  const _Header({
    Key? key,
    this.maxHeight,
    this.minHeight,
    required this.title,
    required this.collapsedTitle,
    required this.collapsedTextSize
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final expandRatio = _calculateExpandRatio(constraints);
        final animation = AlwaysStoppedAnimation(expandRatio);
        return Stack(
          fit: StackFit.expand,
          children: [
            AnimatedOpacity(
              opacity: expandRatio >= 0.2 &&
                  expandRatio <= 0.7 ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              child: _buildTitle(
                  animation,
                  expandRatio <= 0.4
              ),
            )
          ],
        );
      },
    );
  }

  double _calculateExpandRatio(BoxConstraints constraints) {
    var expandRatio = (constraints.maxHeight - minHeight!) / (maxHeight! - minHeight!);
    if (expandRatio > 1.0) expandRatio = 1.0;
    if (expandRatio < 0.0) expandRatio = 0.0;
    return expandRatio;
  }

  Align _buildTitle(Animation<double> animation, bool isCollapsed) {
    return Align(
      alignment: AlignmentTween(
          begin: Alignment.center,
          end: Alignment.bottomLeft
      ).evaluate(animation),
      child: Padding(
        padding: EdgeInsetsTween(
            begin: const EdgeInsets.only(top: 2),
            end: const EdgeInsets.only(left: 16)
        ).evaluate(animation),
        child: Text(
          isCollapsed ?
          collapsedTitle : title,
          style: TextStyle(
            fontSize: Tween<double>(
                begin: 34,
                end: 28
            ).evaluate(animation),
            letterSpacing: Tween<double>(
                begin: 2,
                end: 0.5
            ).evaluate(animation),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
