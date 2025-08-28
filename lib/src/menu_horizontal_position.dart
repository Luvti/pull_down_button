import 'package:flutter/cupertino.dart';

/// A predicted menu's horizontal position for overlay.
enum MenuHorizontalPosition {
  left,
  right,
  center;

  static MenuHorizontalPosition get(Size size, Rect buttonRect) {
    final leftPosition = buttonRect.left;
    final rightPosition = buttonRect.right;
    final width = size.width;
    final widthCenter = width / 2;
    const threshold = 0.2744;
    final leftCenteredThreshold = widthCenter * (1 - threshold);
    final rightCenteredThreshold = widthCenter * threshold + widthCenter;

    if (buttonRect.center.dx == widthCenter ||
        (leftPosition >= leftCenteredThreshold &&
            rightPosition <= rightCenteredThreshold)) {
      return MenuHorizontalPosition.center;
    } else if (leftPosition < width - rightPosition) {
      return MenuHorizontalPosition.left;
    } else {
      return MenuHorizontalPosition.right;
    }
  }
}
