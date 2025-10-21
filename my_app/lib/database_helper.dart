import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  bool _isReady = false;

  DatabaseHelper._init();

  // Simple initialization
  Future<void> get database async {
    if (_isReady) return;
    _isReady = true;
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  String _generateToken() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final random = DateTime.now().microsecondsSinceEpoch.toString();
    return _hashPassword('$timestamp-$random');
  }

  // Add this method inside the DatabaseHelper class
  Future<void> debugPrintDatabase() async {
    await database;

    final users = await _getUsers();
    final sessions = await _getSessions();
    final tokens = await _getResetTokens();

    print('\n========== DATABASE DEBUG ==========');
    print('📊 Total Users: ${users.length}');
    for (var i = 0; i < users.length; i++) {
      print('  User $i: ${users[i]}');
    }

    print('\n🔐 Total Sessions: ${sessions.length}');
    for (var i = 0; i < sessions.length; i++) {
      print('  Session $i: ${sessions[i]}');
    }

    print('\n🔑 Total Reset Tokens: ${tokens.length}');
    for (var i = 0; i < tokens.length; i++) {
      print('  Token $i: ${tokens[i]}');
    }
    print('====================================\n');
  }

  // Helper methods for SharedPreferences storage
  Future<List<Map<String, dynamic>>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('users') ?? '[]';
    final List<dynamic> usersList = json.decode(usersJson);
    return usersList.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<void> _saveUsers(List<Map<String, dynamic>> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('users', json.encode(users));
  }

  Future<List<Map<String, dynamic>>> _getSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsJson = prefs.getString('sessions') ?? '[]';
    final List<dynamic> sessionsList = json.decode(sessionsJson);
    return sessionsList.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<void> _saveSessions(List<Map<String, dynamic>> sessions) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sessions', json.encode(sessions));
  }

  Future<List<Map<String, dynamic>>> _getResetTokens() async {
    final prefs = await SharedPreferences.getInstance();
    final tokensJson = prefs.getString('reset_tokens') ?? '[]';
    final List<dynamic> tokensList = json.decode(tokensJson);
    return tokensList.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<void> _saveResetTokens(List<Map<String, dynamic>> tokens) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('reset_tokens', json.encode(tokens));
  }

  Future<Map<String, dynamic>?> createUser({
    required String username,
    required String email,
    required String password,
  }) async {
    await database;

    final users = await _getUsers();
    final now = DateTime.now().toIso8601String();
    final passwordHash = _hashPassword(password);

    // Check duplicates
    for (var user in users) {
      if (user['email'] == email) return null;
      if (user['username'] == username) return null;
    }

    final newUser = {
      'id': users.length + 1,
      'username': username,
      'email': email,
      'password_hash': passwordHash,
      'created_at': now,
      'updated_at': now,
      'is_active': 1,
    };

    users.add(newUser);
    await _saveUsers(users);

    return {
      'id': newUser['id'],
      'username': username,
      'email': email,
      'created_at': now,
    };
  }

  Future<Map<String, dynamic>?> authenticateUser({
    required String email,
    required String password,
  }) async {
    await database;

    final users = await _getUsers();
    final passwordHash = _hashPassword(password);

    for (var user in users) {
      if (user['email'] == email &&
          user['password_hash'] == passwordHash &&
          user['is_active'] == 1) {
        final sessionToken = _generateToken();
        final now = DateTime.now();
        final expiresAt = now.add(Duration(days: 30));

        final sessions = await _getSessions();
        sessions.add({
          'id': sessions.length + 1,
          'user_id': user['id'],
          'session_token': sessionToken,
          'created_at': now.toIso8601String(),
          'expires_at': expiresAt.toIso8601String(),
          'is_active': 1,
        });
        await _saveSessions(sessions);

        return {
          'user_id': user['id'],
          'username': user['username'],
          'email': user['email'],
          'session_token': sessionToken,
        };
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> validateSession(String sessionToken) async {
    await database;

    final sessions = await _getSessions();
    final users = await _getUsers();
    final now = DateTime.now().toIso8601String();

    for (var session in sessions) {
      if (session['session_token'] == sessionToken &&
          session['is_active'] == 1 &&
          session['expires_at'].compareTo(now) > 0) {
        for (var user in users) {
          if (user['id'] == session['user_id'] && user['is_active'] == 1) {
            return {
              'user_id': user['id'],
              'username': user['username'],
              'email': user['email'],
              'session_token': sessionToken,
            };
          }
        }
      }
    }
    return null;
  }

  Future<void> logout(String sessionToken) async {
    await database;

    final sessions = await _getSessions();
    for (var session in sessions) {
      if (session['session_token'] == sessionToken) {
        session['is_active'] = 0;
      }
    }
    await _saveSessions(sessions);
  }

  Future<bool> emailExists(String email) async {
    await database;

    final users = await _getUsers();
    return users.any((user) => user['email'] == email);
  }

  Future<bool> usernameExists(String username) async {
    await database;

    final users = await _getUsers();
    return users.any((user) => user['username'] == username);
  }

  Future<Map<String, dynamic>?> getUserById(int userId) async {
    await database;

    final users = await _getUsers();
    for (var user in users) {
      if (user['id'] == userId && user['is_active'] == 1) {
        return user;
      }
    }
    return null;
  }

  Future<bool> updateUser({
    required int userId,
    String? username,
    String? email,
  }) async {
    await database;

    final users = await _getUsers();
    bool updated = false;

    for (var user in users) {
      if (user['id'] == userId) {
        if (username != null) user['username'] = username;
        if (email != null) user['email'] = email;
        user['updated_at'] = DateTime.now().toIso8601String();
        updated = true;
        break;
      }
    }

    if (updated) {
      await _saveUsers(users);
    }
    return updated;
  }

  Future<bool> changePassword({
    required int userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    await database;

    final users = await _getUsers();
    final oldPasswordHash = _hashPassword(oldPassword);
    final newPasswordHash = _hashPassword(newPassword);

    for (var user in users) {
      if (user['id'] == userId && user['password_hash'] == oldPasswordHash) {
        user['password_hash'] = newPasswordHash;
        user['updated_at'] = DateTime.now().toIso8601String();
        await _saveUsers(users);
        return true;
      }
    }
    return false;
  }

  Future<String?> createPasswordResetToken(String email) async {
    await database;

    final users = await _getUsers();

    for (var user in users) {
      if (user['email'] == email && user['is_active'] == 1) {
        final resetToken = _generateToken();
        final now = DateTime.now();
        final expiresAt = now.add(Duration(hours: 1));

        final tokens = await _getResetTokens();
        tokens.add({
          'id': tokens.length + 1,
          'user_id': user['id'],
          'reset_token': resetToken,
          'created_at': now.toIso8601String(),
          'expires_at': expiresAt.toIso8601String(),
          'is_used': 0,
        });
        await _saveResetTokens(tokens);
        return resetToken;
      }
    }
    return null;
  }

  Future<bool> resetPasswordWithToken({
    required String resetToken,
    required String newPassword,
  }) async {
    await database;

    final tokens = await _getResetTokens();
    final now = DateTime.now().toIso8601String();
    int? userId;

    for (var token in tokens) {
      if (token['reset_token'] == resetToken &&
          token['is_used'] == 0 &&
          token['expires_at'].compareTo(now) > 0) {
        userId = token['user_id'];
        token['is_used'] = 1;
        break;
      }
    }

    if (userId == null) return false;

    await _saveResetTokens(tokens);

    final users = await _getUsers();
    final newPasswordHash = _hashPassword(newPassword);

    for (var user in users) {
      if (user['id'] == userId) {
        user['password_hash'] = newPasswordHash;
        user['updated_at'] = DateTime.now().toIso8601String();
        await _saveUsers(users);
        return true;
      }
    }

    return false;
  }

  Future<Map<String, dynamic>?> createOrLinkOAuthUser({
    required String providerName,
    required String providerUserId,
    required String email,
    String? username,
  }) async {
    await database;

    // For now, just create a regular user
    return await createUser(
      username: username ?? email.split('@')[0],
      email: email,
      password: _generateToken(),
    );
  }

  Future<void> close() async {
    // Nothing to close for SharedPreferences
  }
}
