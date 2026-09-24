import 'package:flutter/widgets.dart';

/// Width breakpoints for adaptive layout.
abstract final class WindowBreakpoints {
  static const double medium = 600;
  static const double expanded = 1024;
}

/// Coarse window size derived from the shortest logical width.
enum WindowSize { compact, medium, expanded }

/// Reads [WindowSize] from [MediaQuery.sizeOf].
extension WindowSizeContext on BuildContext {
  WindowSize get windowSize {
    final width = MediaQuery.sizeOf(this).width;
    if (width < WindowBreakpoints.medium) {
      return WindowSize.compact;
    }
    if (width < WindowBreakpoints.expanded) {
      return WindowSize.medium;
    }
    return WindowSize.expanded;
  }
}
