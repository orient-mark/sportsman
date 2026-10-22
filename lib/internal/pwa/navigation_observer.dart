import 'package:flutter/widgets.dart';

import 'platform.dart';

/// Updates are applied only on the idle home screen, never over a scanner,
/// participant registration, or result-transfer dialog.
class PwaNavigationObserver extends NavigatorObserver {
  final _routes = <Route<dynamic>>[];

  void _notify() => setPwaSafeToUpdate(
    _routes.isNotEmpty && _routes.last.settings.name == '/home',
  );

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routes.add(route);
    _notify();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routes.remove(route);
    _notify();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routes.remove(route);
    _notify();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final index = oldRoute == null ? -1 : _routes.indexOf(oldRoute);
    if (index >= 0) {
      if (newRoute == null) {
        _routes.removeAt(index);
      } else {
        _routes[index] = newRoute;
      }
    }
    _notify();
  }
}
