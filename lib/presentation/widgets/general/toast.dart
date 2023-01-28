import 'package:flutter/material.dart';

class Toast {
  static void show(context, text, [IconData icon = Icons.error_outline, bool isSuccess = false]) {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(builder: (_) => const SizedBox.shrink());

    const Duration d = Duration(seconds: 1);
    double o = .0;

    overlayEntry = OverlayEntry(builder: (context) =>
      StatefulBuilder(
        builder: (_, setState) {
          WidgetsBinding.instance.addPostFrameCallback((__) {
            if (o == .0) {
              setState(() => o = 1.0);
              Future.delayed(const Duration(seconds: 2) + d).then((_) {
                if (overlayEntry.mounted) setState(() => o = .1);

                Future.delayed(d).then((_) {
                  if (overlayEntry.mounted) overlayEntry.remove();
                });
              });
            }
          });
          final screenWidth = MediaQuery.of(context).size.width;
          return Positioned(
            left: screenWidth / 4.5,
            right: screenWidth / 4.5,
            bottom: 130,
            child: AnimatedOpacity(
              opacity: o,
              duration: d,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  color:  Theme.of(context).brightness == Brightness.dark ?
                  const Color(0xFF1C1C1C) : const Color(0xFFFFFFFF),
                  border: Border.all(color: Colors.grey.shade700, width: 0.15)
                ),
                padding: const EdgeInsets.only(
                  left: 6.6, right: 15.0,
                  top: 8, bottom: 8
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Icon(
                        icon,
                        color: isSuccess ? Colors.green : Colors.redAccent,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Center(
                        child: Text(
                          text,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: Theme.of(context).brightness == Brightness.dark ?
                            Colors.white : Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 11.5
                          ),
                          maxLines: 4,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                  )
              ),
            ),
          );
        },
      )
    );

    overlayState.insert(overlayEntry);
  }
}