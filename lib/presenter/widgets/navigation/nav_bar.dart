import 'package:flutter/material.dart';

class NavBarItem {
  const NavBarItem({this.iconData, this.text, this.selectedIconData, this.iconSize = 28});

  final IconData? selectedIconData;
  final double? iconSize;
  final IconData? iconData;
  final String? text;
}

class NavBar extends StatefulWidget {
  const NavBar({
    Key? key,
    this.items,
    this.fontSize = 14.0,
    this.height = 55.0,
    this.backgroundColor,
    this.color,
    this.centerIndex,
    this.selectedColor,
    this.onTabSelected,
    this.shadowColor,
    this.centerItem,
    this.isWithTitle = false,
  }) : super(key: key);

  final double fontSize;
  final List<NavBarItem>? items;
  final Widget? centerItem;
  final int? centerIndex;
  final bool? isWithTitle;
  final double height;
  final Color? backgroundColor;
  final Color? shadowColor;
  final Color? color;
  final Color? selectedColor;
  final ValueChanged<int?>? onTabSelected;

  @override
  State<StatefulWidget> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> with TickerProviderStateMixin{
  int? _selectedIndex = 0;

  double? _scale;

  Duration animationDuration = const Duration(milliseconds: 200);

  List<AnimationController> animControllers = [];

  @override
  void initState(){
    for (int i = 0; i < widget.items!.length; i++) {
      animControllers.add(AnimationController(
        vsync: this,
        duration: animationDuration,
        lowerBound: 0.0,
        upperBound: 0.2,
      )..addListener(() {
        setState(() {});
      }));
    }
    super.initState();
  }

  @override
  dispose(){
    for (int i = 0; i < widget.items!.length; i++){
      animControllers[i].dispose();
    }
    super.dispose();
  }

  _updateIndex(int? index) {
    widget.onTabSelected!(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items!.length, (int index) {
      return _buildTabItem(
        item: widget.items![index],
        index: index,
        onPressed: _updateIndex,
        isWithTitle: widget.isWithTitle!,
        animationController: animControllers[index]
      );
    });
    if(widget.centerIndex != null && widget.centerItem != null) {
      items.insert(
        widget.centerIndex!,
        widget.centerItem!
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        border: Border(
          top: BorderSide(width: 0.15, color: Colors.grey.withOpacity(0.9)),
        ),
      ),
      height: 55,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items,
      ),
    );
  }

  Widget _buildTabItem({
    required NavBarItem item,
    int? index,
    ValueChanged<int?>? onPressed,
    required bool isWithTitle,
    required AnimationController animationController
  }) {
    Color? color = _selectedIndex == index ? widget.selectedColor : widget.color;
    _scale = 1 - animationController.value;
    return Expanded(
      child: SizedBox(
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            onTap: () async{
              if(_selectedIndex != index){
                onPressed!(index);
              }
              animationController.forward();
              await Future.delayed(animationDuration);
              animationController.reverse();
            },
            child: Transform.scale(
              scale: _scale,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      _selectedIndex == index ?
                      item.selectedIconData ?? item.iconData :
                      item.iconData,
                      size: isWithTitle ? 24 : item.iconSize,
                      color: color,
                    ),
                    if(isWithTitle)
                    Text(
                      item.text!,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: color
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
