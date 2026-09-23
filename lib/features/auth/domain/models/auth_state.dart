import 'auth_tokens.dart';
import 'user_model.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  guest,
  loading,
  error,
}

/// Immutable state container for user authentication.
class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final AuthTokens? tokens;
  final String? errorMessage;
  final bool isBiometricEnabled;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.tokens,
    this.errorMessage,
    this.isBiometricEnabled = false,
  });

  bool get isAuthenticated => status == AuthStatus.authenticated && tokens != null;
  bool get isGuest => status == AuthStatus.guest;
  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    AuthTokens? tokens,
    String? errorMessage,
    bool? isBiometricEnabled,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      tokens: tokens ?? this.tokens,
      errorMessage: errorMessage,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
    );
  }
}
