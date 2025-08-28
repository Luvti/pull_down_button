import 'package:flutter/cupertino.dart';
import '../../pull_down_button.dart';
import '../_internals/animation.dart';
import '../_internals/content_size_category.dart';
import '../_internals/menu.dart';
import 'overlay_menu_body.dart';

/// Overlay version of RoutePullDownMenu
class OverlayPullDownMenu extends StatelessWidget {
  const OverlayPullDownMenu({
    required this.items,
    required this.routeTheme,
    required this.alignment,
    required this.animation,
    required this.scrollController,
    required this.onItemSelected,
  });

  final List<PullDownMenuEntry> items;
  final PullDownMenuRouteTheme? routeTheme;
  final Animation<double> animation;
  final Alignment alignment;
  final ScrollController? scrollController;
  final void Function(VoidCallback) onItemSelected;

  @override
  Widget build(BuildContext context) {
    final theme =
        PullDownMenuRouteTheme.resolve(context, routeTheme: routeTheme);

    final shadowTween = DecorationTween(
      begin: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: theme.shadow!.color.withValues(alpha: 0),
            blurRadius: theme.shadow!.blurRadius,
            spreadRadius: theme.shadow!.spreadRadius,
          ),
        ],
      ),
      end: BoxDecoration(boxShadow: [theme.shadow!]),
    );

    final clampedAnimation = ClampedAnimation(animation);

    final isInAccessibilityMode = TextUtils.isInAccessibilityMode(context);

    return ScaleTransition(
      scale: animation,
      alignment: alignment,
      child: DecoratedBoxTransition(
        decoration: AnimationUtils.shadowTween
            .animate(clampedAnimation)
            .drive(shadowTween),
        child: FadeTransition(
          opacity: clampedAnimation,
          child: MenuDecoration(
            backgroundColor: theme.backgroundColor!,
            borderRadius: theme.borderRadius!,
            child: FadeTransition(
              opacity: clampedAnimation,
              child: AnimatedMenuContainer(
                constraints: BoxConstraints.tightFor(
                  width: isInAccessibilityMode
                      ? theme.accessibilityWidth
                      : theme.width,
                ),
                child: SizeTransition(
                  axisAlignment: -1,
                  sizeFactor: clampedAnimation,
                  child: OverlayMenuBody(
                    scrollController: scrollController,
                    items: items,
                    onItemSelected: onItemSelected,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
