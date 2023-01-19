import 'package:flutter/material.dart';

class BouncingButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPress;

  const BouncingButton({
    Key? key,
    required this.child,
    required this.onPress
  }) : super(key: key);

  @override
  State createState() => _BouncingButtonState();
}

class _BouncingButtonState extends State<BouncingButton> with SingleTickerProviderStateMixin {
  Animation<double>? _scale;
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.85).animate(CurvedAnimation(parent: _controller!, curve: Curves.ease));
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) {
        _controller!.forward();
      },
      onPointerUp: (PointerUpEvent event) {
        _controller!.reverse();
        widget.onPress();
      },
      child: ScaleTransition(
        scale: _scale!,
        child: widget.child,
      ),
    );
  }
}