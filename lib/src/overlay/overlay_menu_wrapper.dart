import 'package:flutter/cupertino.dart';
import '../../pull_down_button.dart';
import 'overlay_menu_route_layout.dart';
import 'overlay_pull_down_menu.dart';

/// Wrapper widget for displaying menu in overlay
class OverlayMenuWrapper extends StatelessWidget {
  const OverlayMenuWrapper({
    required this.buttonRect,
    required this.items,
    required this.menuPosition,
    required this.itemsOrder,
    required this.routeTheme,
    required this.hasLeading,
    required this.animationAlignment,
    required this.menuOffset,
    required this.scrollController,
    required this.animation,
    required this.onDismiss,
    required this.onItemSelected,
    super.key,
  });

  final Rect buttonRect;
  final List<PullDownMenuEntry> items;
  final PullDownMenuPosition menuPosition;
  final PullDownMenuItemsOrder itemsOrder;
  final PullDownMenuRouteTheme? routeTheme;
  final bool hasLeading;
  final Alignment animationAlignment;
  final double menuOffset;
  final ScrollController? scrollController;
  final Animation<double> animation;
  final VoidCallback onDismiss;
  final void Function(VoidCallback) onItemSelected;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final avoidBounds = DisplayFeatureSubScreen.avoidBounds(mediaQuery).toSet();

    final orderedItems = switch (itemsOrder) {
      PullDownMenuItemsOrder.downwards => items,
      PullDownMenuItemsOrder.upwards => items.reversed,
      PullDownMenuItemsOrder.automatic =>
        animationAlignment.y == -1 ? items : items.reversed
    };

    return GestureDetector(
      onTap: onDismiss,
      behavior: HitTestBehavior.translucent,
      child: SizedBox.expand(
        child: CustomSingleChildLayout(
          delegate: OverlayMenuRouteLayout(
            buttonRect: buttonRect,
            padding: mediaQuery.padding,
            avoidBounds: avoidBounds,
            menuPosition: menuPosition,
            menuOffset: menuOffset,
          ),
          child: MenuConfig(
            hasLeading: hasLeading,
            child: OverlayPullDownMenu(
              scrollController: scrollController,
              items: orderedItems.toList(),
              routeTheme: routeTheme,
              animation: animation,
              alignment: animationAlignment,
              onItemSelected: onItemSelected,
            ),
          ),
        ),
      ),
    );
  }
}
