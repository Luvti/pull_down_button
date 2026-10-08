import 'dart:async';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pull_down_button/pull_down_button.dart';

const _theme = PullDownButtonTheme(
  itemTheme: PullDownMenuItemTheme(
    textStyle: TextStyle(color: Color(0xFF673AB7)),
  ),
);

void main() {
  for (final cupertino in [false, true]) {
    final host = cupertino ? 'CupertinoApp' : 'MaterialApp';

    testWidgets('$host applies the menu theme and selects an overlay item', (
      tester,
    ) async {
      var selections = 0;
      final controller = PullDownMenuController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _app(
          cupertino: cupertino,
          child: PullDownButton(
            controller: controller,
            itemBuilder: (_) => [
              PullDownMenuItem.selectable(
                title: 'Archive',
                selected: true,
                onTap: () => selections++,
              ),
            ],
            buttonBuilder: (_, showMenu) => CupertinoButton(
              onPressed: showMenu,
              child: const Text('Open menu'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open menu'));
      await tester.pumpAndSettle();

      expect(controller.isMenuOpen, isTrue);
      _expectThemedItem(tester);

      await tester.tap(find.text('Archive'));
      await tester.pumpAndSettle();

      expect(selections, 1);
      expect(controller.isMenuOpen, isFalse);
      expect(find.text('Archive'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('$host applies the menu theme to showPullDownMenu', (
      tester,
    ) async {
      var selections = 0;

      await tester.pumpWidget(
        _app(
          cupertino: cupertino,
          child: Builder(
            builder: (context) => CupertinoButton(
              onPressed: () => unawaited(
                showPullDownMenu(
                  context: context,
                  position: const Rect.fromLTWH(300, 200, 100, 40),
                  items: [
                    PullDownMenuItem(
                      title: 'Archive',
                      onTap: () => selections++,
                    ),
                  ],
                ),
              ),
              child: const Text('Open menu'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open menu'));
      await tester.pumpAndSettle();

      _expectThemedItem(tester);

      await tester.tap(find.text('Archive'));
      await tester.pumpAndSettle();

      expect(selections, 1);
      expect(find.text('Archive'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}

Widget _app({required bool cupertino, required Widget child}) {
  final home = Center(child: child);
  if (cupertino) {
    return CupertinoApp(
      theme: const CupertinoThemeData(brightness: Brightness.dark),
      builder: (_, child) =>
          PullDownButtonInheritedTheme(data: _theme, child: child!),
      home: CupertinoPageScaffold(child: home),
    );
  }

  return MaterialApp(
    theme: ThemeData(extensions: const [_theme]),
    home: Scaffold(body: home),
  );
}

void _expectThemedItem(WidgetTester tester) {
  final item = find.text('Archive');
  expect(item, findsOneWidget);
  expect(PullDownButtonTheme.maybeOf(tester.element(item)), _theme);
  expect(
    tester.widget<Text>(item).style?.color,
    _theme.itemTheme!.textStyle!.color,
  );
}
