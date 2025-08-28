import 'package:flutter/cupertino.dart';
import '../../pull_down_button.dart';
import '../_internals/menu.dart';

/// Overlay version of MenuBody that handles item selection
class OverlayMenuBody extends StatelessWidget {
  const OverlayMenuBody({
    required this.items,
    required this.scrollController,
    required this.onItemSelected,
    super.key,
  });

  final List<PullDownMenuEntry> items;
  final ScrollController? scrollController;
  final void Function(VoidCallback) onItemSelected;

  @override
  Widget build(BuildContext context) {
    return MenuBody(
      scrollController: scrollController,
      items: items.map<PullDownMenuEntry>((item) {
        void overlayTapHandler(BuildContext context, VoidCallback? onTap) {
          if (onTap != null) {
            onItemSelected(onTap);
          }
        }

        if (item is PullDownMenuItem) {
          if (item.selected != null) {
            return PullDownMenuItem.selectable(
              title: item.title,
              subtitle: item.subtitle,
              icon: item.icon,
              iconColor: item.iconColor,
              iconWidget: item.iconWidget,
              iconTooltip: item.iconTooltip,
              contentWidget: item.contentWidget,
              replaceIconWidget: item.replaceIconWidget,
              itemTheme: item.itemTheme,
              isDestructive: item.isDestructive,
              selected: item.selected,
              enabled: item.enabled,
              tapHandler: overlayTapHandler,
              onTap: item.onTap,
            );
          } else {
            return PullDownMenuItem(
              title: item.title,
              subtitle: item.subtitle,
              icon: item.icon,
              iconColor: item.iconColor,
              iconWidget: item.iconWidget,
              iconTooltip: item.iconTooltip,
              contentWidget: item.contentWidget,
              replaceIconWidget: item.replaceIconWidget,
              itemTheme: item.itemTheme,
              isDestructive: item.isDestructive,
              enabled: item.enabled,
              tapHandler: overlayTapHandler,
              onTap: item.onTap,
            );
          }
        } else if (item is PullDownMenuHeader) {
          return PullDownMenuHeader(
            leading: item.leading,
            leadingBuilder: item.leadingBuilder,
            title: item.title,
            subtitle: item.subtitle,
            itemTheme: item.itemTheme,
            icon: item.icon,
            iconWidget: item.iconWidget,
            tapHandler: overlayTapHandler,
            onTap: item.onTap,
          );
        } else if (item is PullDownMenuActionsRow) {
          final newItems = item.items.map((actionItem) {
            if (actionItem.selected != null) {
              return PullDownMenuItem.selectable(
                title: actionItem.title,
                subtitle: actionItem.subtitle,
                icon: actionItem.icon,
                iconColor: actionItem.iconColor,
                iconWidget: actionItem.iconWidget,
                iconTooltip: actionItem.iconTooltip,
                contentWidget: actionItem.contentWidget,
                replaceIconWidget: actionItem.replaceIconWidget,
                itemTheme: actionItem.itemTheme,
                isDestructive: actionItem.isDestructive,
                selected: actionItem.selected,
                enabled: actionItem.enabled,
                tapHandler: overlayTapHandler,
                onTap: actionItem.onTap,
              );
            } else {
              return PullDownMenuItem(
                title: actionItem.title,
                subtitle: actionItem.subtitle,
                icon: actionItem.icon,
                iconColor: actionItem.iconColor,
                iconWidget: actionItem.iconWidget,
                iconTooltip: actionItem.iconTooltip,
                contentWidget: actionItem.contentWidget,
                replaceIconWidget: actionItem.replaceIconWidget,
                itemTheme: actionItem.itemTheme,
                isDestructive: actionItem.isDestructive,
                enabled: actionItem.enabled,
                tapHandler: overlayTapHandler,
                onTap: actionItem.onTap,
              );
            }
          }).toList();

          if (item.items.length <= 3) {
            return PullDownMenuActionsRow.medium(
              items: newItems,
              showVerticalSeparators: item.showVerticalSeparators,
            );
          } else {
            return PullDownMenuActionsRow.small(
              items: newItems,
              showVerticalSeparators: item.showVerticalSeparators,
            );
          }
        }
        return item;
      }).toList(),
    );
  }
}
