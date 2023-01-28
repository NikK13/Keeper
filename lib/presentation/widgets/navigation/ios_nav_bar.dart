import 'package:flutter/material.dart';

class IosBarItem {
  IosBarItem({this.iconData, this.text});
  IconData? iconData;
  String? text;
}

class IosNavigationBar extends StatefulWidget {
  const IosNavigationBar({
    Key? key,
    this.items,
    this.fontSize = 14.0,
    this.height = 55.0,
    this.iconSize = 24.0,
    this.backgroundColor,
    this.color,
    this.selectedColor,
    this.onTabSelected,
    this.shadowColor,
    this.isWithTitle = false,
  }) : super(key: key);

  final double fontSize;
  final List<IosBarItem>? items;
  final bool? isWithTitle;
  final double height;
  final double iconSize;
  final Color? backgroundColor;
  final Color? shadowColor;
  final Color? color;
  final Color? selectedColor;
  final ValueChanged<int?>? onTabSelected;

  @override
  State<StatefulWidget> createState() => _IosNavigationBarState();
}

class _IosNavigationBarState extends State<IosNavigationBar> {
  int? _selectedIndex = 0;

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
      );
    });
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        border: Border(
          top: BorderSide(width: 0.275, color: Colors.grey.withOpacity(0.9)),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items,
      ),
    );
  }

  Widget _buildTabItem({
    required IosBarItem item,
    int? index,
    ValueChanged<int?>? onPressed,
    required bool isWithTitle,
  }) {
    Color? color = _selectedIndex == index ? widget.selectedColor : widget.color;
    return Expanded(
      child: SizedBox(
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () => onPressed!(index),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    item.iconData,
                    size: widget.iconSize,
                    color: color,
                  ),
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
    );
  }
}
