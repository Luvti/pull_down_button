import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../pull_down_button.dart';
import '../menu_horizontal_position.dart';
import '../pull_down_button.dart';

/// Positioning and size of the menu on the screen for overlay.
@immutable
class OverlayMenuRouteLayout extends SingleChildLayoutDelegate {
  const OverlayMenuRouteLayout({
    required this.padding,
    required this.avoidBounds,
    required this.buttonRect,
    required this.menuPosition,
    required this.menuOffset,
  });

  final EdgeInsets padding;
  final Set<Rect> avoidBounds;
  final Rect buttonRect;
  final PullDownMenuPosition menuPosition;
  final double menuOffset;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final biggest = constraints.biggest;
    final constraintsHeight = biggest.height;
    final check = buttonRect.center.dy >= constraintsHeight / 2;

    final height = switch (menuPosition) {
      PullDownMenuPosition.over when check => buttonRect.bottom - padding.top,
      PullDownMenuPosition.over =>
        constraintsHeight - buttonRect.top - padding.bottom,
      PullDownMenuPosition.automatic when check => buttonRect.top - padding.top,
      PullDownMenuPosition.automatic =>
        constraintsHeight - buttonRect.bottom - padding.bottom,
    };

    return BoxConstraints.loose(
      Size(biggest.width, height),
    ).deflate(
      const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final childWidth = childSize.width;
    final horizontalPosition = MenuHorizontalPosition.get(size, buttonRect);

    final x = switch (horizontalPosition) {
      MenuHorizontalPosition.right =>
        buttonRect.right - childWidth + menuOffset,
      MenuHorizontalPosition.left => buttonRect.left - menuOffset,
      MenuHorizontalPosition.center =>
        buttonRect.left + buttonRect.width / 2 - childWidth / 2
    };

    final originCenter = buttonRect.center;
    final rect = Offset.zero & size;
    final subScreens =
        DisplayFeatureSubScreen.subScreensInBounds(rect, avoidBounds);
    final subScreen = _closestScreen(subScreens, originCenter);

    final dx = _fitX(x, subScreen, childWidth, padding);
    final dy = _fitY(
      buttonRect,
      subScreen,
      childSize.height,
      padding,
      menuPosition,
    );

    return Offset(dx, dy);
  }

  @override
  bool shouldRelayout(OverlayMenuRouteLayout oldDelegate) =>
      padding != oldDelegate.padding ||
      !setEquals(avoidBounds, oldDelegate.avoidBounds) ||
      buttonRect != oldDelegate.buttonRect ||
      menuPosition != oldDelegate.menuPosition;

  static Rect _closestScreen(Iterable<Rect> screens, Offset point) {
    var closest = screens.first;
    for (final screen in screens) {
      if ((screen.center - point).distance <
          (closest.center - point).distance) {
        closest = screen;
      }
    }
    return closest;
  }

  static double _fitY(
    Rect buttonRect,
    Rect screen,
    double childHeight,
    EdgeInsets padding,
    PullDownMenuPosition menuPosition,
  ) {
    var y = buttonRect.top;
    final buttonHeight = buttonRect.height;
    final isInBottomHalf = y + buttonHeight / 2 >= screen.height / 2;

    switch (menuPosition) {
      case PullDownMenuPosition.over:
        if (isInBottomHalf) {
          y -= childHeight - buttonHeight;
        }
      case PullDownMenuPosition.automatic:
        final padding = buttonHeight < 44 ? 5 : 0;
        isInBottomHalf
            ? y -= childHeight + padding
            : y += buttonHeight + padding;
    }

    return y;
  }

  static double _fitX(
    double wantedX,
    Rect screen,
    double childWidth,
    EdgeInsets padding,
  ) {
    const kMenuScreenPadding = 8.0;
    final leftSafeArea = screen.left + kMenuScreenPadding + padding.left;
    final rightSafeArea = screen.right - kMenuScreenPadding - padding.right;

    if (wantedX < leftSafeArea) {
      return leftSafeArea;
    } else if (wantedX + childWidth > rightSafeArea) {
      return rightSafeArea - childWidth;
    }

    return wantedX;
  }
}
