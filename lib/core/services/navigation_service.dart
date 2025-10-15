import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Navigation service interface for testability and abstraction
abstract class INavigationService {
  Future<void> navigateToInput();
  Future<void> navigateToResult();
  Future<void> navigateToHome();
  void goBack();
  bool canGoBack();
}

/// Implementation of navigation service using GoRouter
class NavigationService implements INavigationService {
  final GoRouter _router;
  
  NavigationService(this._router);

  @override
  Future<void> navigateToInput() async {
    _router.go('/input');
  }

  @override
  Future<void> navigateToResult() async {
    _router.go('/result');
  }

  @override
  Future<void> navigateToHome() async {
    _router.go('/');
  }

  @override
  void goBack() {
    if (_router.canPop()) {
      _router.pop();
    }
  }

  @override
  bool canGoBack() {
    return _router.canPop();
  }
}

/// Navigation service provider
final navigationServiceProvider = Provider<INavigationService>((ref) {
  // For safety, provide a mock implementation that doesn't crash
  // In practice, use ContextNavigationService with actual context
  return _MockNavigationService();
});

/// Extension for easier access in widgets
extension NavigationExtension on WidgetRef {
  INavigationService get navigation => read(navigationServiceProvider);
}

/// Mock navigation service to prevent null reference errors
class _MockNavigationService implements INavigationService {
  @override
  Future<void> navigateToInput() async {
    // No-op in mock
  }

  @override
  Future<void> navigateToResult() async {
    // No-op in mock
  }

  @override
  Future<void> navigateToHome() async {
    // No-op in mock
  }

  @override
  void goBack() {
    // No-op in mock
  }

  @override
  bool canGoBack() => false;
}

/// Context-based navigation service (when ref is not available)
class ContextNavigationService implements INavigationService {
  final BuildContext context;
  
  ContextNavigationService(this.context);

  @override
  Future<void> navigateToInput() async {
    if (context.mounted) {
      context.go('/input');
    }
  }

  @override
  Future<void> navigateToResult() async {
    if (context.mounted) {
      context.go('/result');
    }
  }

  @override
  Future<void> navigateToHome() async {
    if (context.mounted) {
      context.go('/');
    }
  }

  @override
  void goBack() {
    if (context.mounted && context.canPop()) {
      context.pop();
    }
  }

  @override
  bool canGoBack() {
    return context.mounted && context.canPop();
  }
}
