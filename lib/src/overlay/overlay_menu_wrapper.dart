import 'dart:async';

import 'package:flutter/cupertino.dart';
import '../../pull_down_button.dart';
import 'overlay_menu_route_layout.dart';
import 'overlay_pull_down_menu.dart';

/// Wrapper widget for displaying menu in overlay
class OverlayMenuWrapper extends StatelessWidget {
  const OverlayMenuWrapper({
    required this.buttonRect,
    required this.itemBuilder,
    required this.menuPosition,
    required this.itemsOrder,
    required this.routeTheme,
    required this.animationAlignment,
    required this.menuOffset,
    required this.scrollController,
    required this.animation,
    required this.onDismiss,
    required this.onItemSelected,
    this.rebuildStream,
    super.key,
  });

  final Rect buttonRect;
  final PullDownMenuItemBuilder itemBuilder;
  final PullDownMenuPosition menuPosition;
  final PullDownMenuItemsOrder itemsOrder;
  final PullDownMenuRouteTheme? routeTheme;
  final Alignment animationAlignment;
  final double menuOffset;
  final ScrollController? scrollController;
  final Animation<double> animation;
  final VoidCallback onDismiss;
  final void Function(VoidCallback) onItemSelected;
  final Stream<void>? rebuildStream;

  @override
  Widget build(BuildContext context) {
    return rebuildStream != null
        ? StreamBuilder<void>(
            stream: rebuildStream,
            builder: (context, snapshot) => _buildMenu(context),
          )
        : _buildMenu(context);
  }

  Widget _buildMenu(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final avoidBounds = DisplayFeatureSubScreen.avoidBounds(mediaQuery).toSet();

    final items = itemBuilder(context);
    final hasLeading = MenuConfig.menuHasLeading(items);

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
