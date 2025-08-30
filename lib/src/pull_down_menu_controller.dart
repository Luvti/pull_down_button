import 'dart:async';

import 'package:flutter/foundation.dart';

import '../pull_down_button.dart';

/// Controller for managing [PullDownButton] menu state.
///
/// Allows external control over menu visibility and provides
/// callbacks for menu state changes.
class PullDownMenuController extends ChangeNotifier {
  /// Creates a new [PullDownMenuController].
  PullDownMenuController();
  StreamController<bool>? _closeStreamController;
  bool _isMenuOpen = false;

  /// Whether the menu is currently open.
  bool get isMenuOpen => _isMenuOpen;

  /// Stream that emits when the menu should be closed.
  /// Internal use only.
  Stream<bool> get closeStream {
    _closeStreamController ??= StreamController<bool>.broadcast();
    return _closeStreamController!.stream;
  }

  /// Closes the menu if it's currently open.
  ///
  /// Returns `true` if the menu was open and closed, `false` otherwise.
  bool close({bool handleCancel = true}) {
    if (!_isMenuOpen) return false;

    _closeStreamController?.add(handleCancel);
    return true;
  }

  /// Internal method to set menu open state.
  /// Should only be called by [PullDownButton].
  void setMenuOpen({required bool isOpen}) {
    if (_isMenuOpen != isOpen) {
      _isMenuOpen = isOpen;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _closeStreamController?.close();
    super.dispose();
  }
}
