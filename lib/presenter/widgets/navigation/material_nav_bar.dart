import 'package:flutter/material.dart';

class MaterialBarItem {
  MaterialBarItem({this.iconData, this.text, this.selectedIconData});
  IconData? selectedIconData;
  IconData? iconData;
  String? text;
}

class MaterialBar extends StatefulWidget {
  const MaterialBar({
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
  final List<MaterialBarItem>? items;
  final bool? isWithTitle;
  final double height;
  final double iconSize;
  final Color? backgroundColor;
  final Color? shadowColor;
  final Color? color;
  final Color? selectedColor;
  final ValueChanged<int?>? onTabSelected;

  @override
  State<StatefulWidget> createState() => _MaterialBarState();
}

class _MaterialBarState extends State<MaterialBar> {
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
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items,
      ),
    );
  }

  Widget _buildTabItem({
    required MaterialBarItem item,
    int? index,
    ValueChanged<int?>? onPressed,
    required bool isWithTitle,
  }) {
    return Expanded(
      child: SizedBox(
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            onTap: () => onPressed!(index),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _selectedIndex == index ?
                  Container(
                    decoration: _selectedIndex == index ? BoxDecoration(
                      color: widget.selectedColor,
                      borderRadius: BorderRadius.circular(20)
                    ) : null,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 3
                    ),
                    child: Icon(item.selectedIconData ?? item.iconData, color: Colors.white, size: widget.iconSize)
                  ) :
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 3
                    ),
                    child: Icon(
                      item.iconData,
                      size: widget.iconSize,
                      color: Theme.of(context).brightness == Brightness.dark ?
                      Colors.white : Colors.black,
                    )
                  ),
                  if (isWithTitle)
                  Text(
                    item.text!,
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      fontWeight: FontWeight.w600
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
