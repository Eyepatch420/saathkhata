import 'package:flutter/foundation.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';

/// Bridges AuthBloc to GoRouter's refreshListenable so the router
/// re-evaluates its redirect whenever auth state changes.
class AuthStateNotifier extends ChangeNotifier {
  AuthState _authState = const AuthInitial();

  AuthState get authState => _authState;

  void onAuthStateChanged(AuthState state) {
    _authState = state;
    // Skip intermediate states — the router only needs to react to
    // AuthAuthenticated / AuthUnauthenticated / AuthError.
    if (state is AuthInitial || state is AuthLoading) return;
    notifyListeners();
  }

  /// Called by ApiClient when a token refresh fails and the session is
  /// cleared, so the router redirects to login immediately instead of
  /// leaving the user stuck on a screen with silently-failing requests.
  void forceUnauthenticated() {
    _authState = const AuthUnauthenticated();
    notifyListeners();
  }
}
