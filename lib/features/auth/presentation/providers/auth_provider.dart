import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/auth_api_service.dart';
import '../../data/services/token_storage_service.dart';
import '../../domain/models/auth_state.dart';
import '../../domain/models/auth_tokens.dart';

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final apiService = ref.read(authApiServiceProvider);
  final storageService = ref.read(tokenStorageServiceProvider);
  return AuthNotifier(apiService, storageService);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthApiService _apiService;
  final TokenStorageService _storageService;

  AuthNotifier(this._apiService, this._storageService) : super(const AuthState()) {
    checkInitialSession();
  }

  /// Check stored tokens upon cold app launch
  Future<void> checkInitialSession() async {
    final accessToken = await _storageService.getAccessToken();
    final refreshToken = await _storageService.getRefreshToken();
    final user = await _storageService.getUser();
    final isBiometric = await _storageService.isBiometricEnabled();

    if (accessToken != null && refreshToken != null && user != null) {
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        tokens: AuthTokens(accessToken: accessToken, refreshToken: refreshToken),
        isBiometricEnabled: isBiometric,
      );
    } else {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        isBiometricEnabled: isBiometric,
      );
    }
  }

  /// Request OTP via SMS
  Future<bool> requestOtp(String phone) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final success = await _apiService.requestOtp(phone);
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return success;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Verify OTP and persist session
  Future<bool> verifyOtp(String phone, String otp) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final res = await _apiService.verifyOtp(phone, otp);
      await _storageService.saveTokens(res.tokens);
      await _storageService.saveUser(res.user);

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: res.user,
        tokens: res.tokens,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Invalid OTP code. Please check and try again.',
      );
      return false;
    }
  }

  /// Google Sign-In
  Future<bool> signInWithGoogle() async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final res = await _apiService.signInWithGoogle('mock_google_id_token');
      await _storageService.saveTokens(res.tokens);
      await _storageService.saveUser(res.user);

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: res.user,
        tokens: res.tokens,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Google Sign-In failed.',
      );
      return false;
    }
  }

  /// Apple Sign-In
  Future<bool> signInWithApple() async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final res = await _apiService.signInWithApple('mock_apple_id_token');
      await _storageService.saveTokens(res.tokens);
      await _storageService.saveUser(res.user);

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: res.user,
        tokens: res.tokens,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Apple Sign-In failed.',
      );
      return false;
    }
  }

  /// Email & Password Login
  Future<bool> loginWithEmail(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final res = await _apiService.loginWithEmail(email, password);
      await _storageService.saveTokens(res.tokens);
      await _storageService.saveUser(res.user);

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: res.user,
        tokens: res.tokens,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Invalid email or password.',
      );
      return false;
    }
  }

  /// Email & Password Register
  Future<bool> registerWithEmail({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final res = await _apiService.registerWithEmail(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
      );
      await _storageService.saveTokens(res.tokens);
      await _storageService.saveUser(res.user);

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: res.user,
        tokens: res.tokens,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Registration failed. Please try again.',
      );
      return false;
    }
  }

  /// Guest Mode
  void continueAsGuest() {
    state = state.copyWith(
      status: AuthStatus.guest,
      user: null,
      tokens: null,
    );
  }

  /// Toggle Biometric App Lock
  Future<void> toggleBiometrics(bool enabled) async {
    await _storageService.setBiometricEnabled(enabled);
    state = state.copyWith(isBiometricEnabled: enabled);
  }

  /// Log out and clear session
  Future<void> logout() async {
    await _storageService.clearAll();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}
