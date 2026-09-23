import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/models/auth_tokens.dart';
import '../../domain/models/user_model.dart';

final tokenStorageServiceProvider = Provider<TokenStorageService>((ref) {
  return TokenStorageService();
});

/// Service responsible for persisting auth tokens and session state in Hive.
class TokenStorageService {
  Box? _box;

  Future<Box> _getBox() async {
    if (_box != null && _box!.isOpen) return _box!;
    try {
      if (!Hive.isBoxOpen(AppConstants.authBoxName)) {
        _box = await Hive.openBox(AppConstants.authBoxName);
      } else {
        _box = Hive.box(AppConstants.authBoxName);
      }
    } catch (_) {
      // In-memory fallback if Hive is not yet initialized
      _box = await Hive.openBox(AppConstants.authBoxName);
    }
    return _box!;
  }

  Future<void> saveTokens(AuthTokens tokens) async {
    final box = await _getBox();
    await box.put(AppConstants.keyAccessToken, tokens.accessToken);
    await box.put(AppConstants.keyRefreshToken, tokens.refreshToken);
  }

  Future<String?> getAccessToken() async {
    final box = await _getBox();
    return box.get(AppConstants.keyAccessToken) as String?;
  }

  Future<String?> getRefreshToken() async {
    final box = await _getBox();
    return box.get(AppConstants.keyRefreshToken) as String?;
  }

  Future<void> saveUser(UserModel user) async {
    final box = await _getBox();
    await box.put('user_profile_json', jsonEncode(user.toJson()));
  }

  Future<UserModel?> getUser() async {
    final box = await _getBox();
    final raw = box.get('user_profile_json') as String?;
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return UserModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    final box = await _getBox();
    await box.put(AppConstants.keyBiometricEnabled, enabled);
  }

  Future<bool> isBiometricEnabled() async {
    final box = await _getBox();
    return (box.get(AppConstants.keyBiometricEnabled) as bool?) ?? false;
  }

  Future<void> clearAll() async {
    final box = await _getBox();
    await box.clear();
  }
}
