import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../pull_down_button.dart';
import '_fonts.dart';

/// Defines the visual properties of the titles in pull-down menus.
///
/// Is used by [PullDownMenuTitle].
///
/// All [PullDownMenuTitleTheme] properties are `null` by default. When null,
/// the pull-down menu will use iOS 16 defaults specified in
/// [PullDownMenuTitleTheme.defaults].
@immutable
class PullDownMenuTitleTheme with Diagnosticable {
  /// Creates the set of properties used to configure [PullDownMenuTitleTheme].
  const PullDownMenuTitleTheme({
    this.style,
  });

  /// Creates default set of properties used to configure
  /// [PullDownMenuTitleTheme].
  ///
  /// Default properties were taken from the Apple Design Resources Sketch file.
  ///
  /// See also:
  ///
  /// * Apple Design Resources Sketch file:
  ///   https://developer.apple.com/design/resources/
  @internal
  const factory PullDownMenuTitleTheme.defaults(BuildContext context) =
      _PullDownMenuTitleDefaults;

  /// The text style of title in the pull-down menu.
  final TextStyle? style;

  /// The [PullDownButtonTheme.titleTheme] property of the ambient
  /// [PullDownButtonTheme].
  static PullDownMenuTitleTheme? maybeOf(BuildContext context) =>
      PullDownButtonTheme.maybeOf(context)?.titleTheme;

  /// The helper method to quickly resolve [PullDownMenuTitleTheme] from
  /// [PullDownButtonTheme.titleTheme] or [PullDownMenuTitleTheme.defaults]
  /// as well as from theme data from [PullDownMenuTitle].
  @internal
  static PullDownMenuTitleTheme resolve(
    BuildContext context, {
    required TextStyle? titleStyle,
  }) {
    final theme = PullDownMenuTitleTheme.maybeOf(context);
    final defaults = PullDownMenuTitleTheme.defaults(context);

    return PullDownMenuTitleTheme(
      style: defaults.style!.merge(theme?.style).merge(titleStyle),
    );
  }

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  PullDownMenuTitleTheme copyWith({
    TextStyle? style,
  }) =>
      PullDownMenuTitleTheme(
        style: style ?? this.style,
      );

  /// Linearly interpolate between two themes.
  static PullDownMenuTitleTheme lerp(
    PullDownMenuTitleTheme? a,
    PullDownMenuTitleTheme? b,
    double t,
  ) {
    if (identical(a, b) && a != null) return a;

    return PullDownMenuTitleTheme(
      style: TextStyle.lerp(a?.style, b?.style, t),
    );
  }

  @override
  int get hashCode => Object.hashAll([style]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is PullDownMenuTitleTheme && other.style == style;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty('style', style, defaultValue: null),
    );
  }
}

/// A set of default values for [PullDownMenuTitleTheme].
@immutable
class _PullDownMenuTitleDefaults extends PullDownMenuTitleTheme {
  /// Creates [_PullDownMenuTitleDefaults].
  const _PullDownMenuTitleDefaults(this.context);

  /// A build context used to resolve [CupertinoDynamicColor]s defined in this
  /// theme.
  final BuildContext context;

  /// The light and dark colors of [PullDownMenuTitle.title].
  static const kTitleColor = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(60, 60, 67, 0.6),
    darkColor: Color.fromRGBO(235, 235, 245, 0.6),
  );

  /// The [PullDownMenuTitleTheme.style] as a constant.
  ///
  /// [style] will resolve [kStyle] with [kTitleColor] applied.
  static const kStyle = TextStyle(
    inherit: false,
    fontFamily: kFontFamily,
    fontFamilyFallback: kFontFallbacks,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
    textBaseline: TextBaseline.alphabetic,
  );

  @override
  TextStyle get style => kStyle.copyWith(
        color: kTitleColor.resolveFrom(context),
      );
}
