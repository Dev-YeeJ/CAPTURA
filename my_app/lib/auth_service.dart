import 'package:shared_preferences/shared_preferences.dart';
import 'database_helper.dart';

class AuthService {
  static final AuthService instance = AuthService._init();
  DatabaseHelper? _db;

  String? _currentSessionToken;
  Map<String, dynamic>? _currentUser;
  bool _isInitialized = false;

  AuthService._init();

  // Initialize auth service (check for existing session)
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize database
      _db = DatabaseHelper.instance;
      await _db!.database; // Force database creation

      final prefs = await SharedPreferences.getInstance();
      _currentSessionToken = prefs.getString('session_token');

      if (_currentSessionToken != null) {
        _currentUser = await _db!.validateSession(_currentSessionToken!);
        if (_currentUser == null) {
          // Invalid session, clear it
          await logout();
        }
      }

      _isInitialized = true;
      print('AuthService initialized successfully');
    } catch (e) {
      print('Error initializing AuthService: $e');
      rethrow;
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  // Check if user is logged in
  bool get isLoggedIn => _currentUser != null;

  // Get current user
  Map<String, dynamic>? get currentUser => _currentUser;

  // Sign up with email and password
  Future<AuthResult> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    await _ensureInitialized();

    try {
      // Validate input
      if (username.isEmpty) {
        return AuthResult.error('Username is required');
      }
      if (email.isEmpty) {
        return AuthResult.error('Email is required');
      }
      if (!_isValidEmail(email)) {
        return AuthResult.error('Invalid email format');
      }
      if (password.length < 6) {
        return AuthResult.error('Password must be at least 6 characters');
      }

      // Check if email already exists
      if (await _db!.emailExists(email)) {
        return AuthResult.error('Email already registered');
      }

      // Check if username already exists
      if (await _db!.usernameExists(username)) {
        return AuthResult.error('Username already taken');
      }

      // Create user
      final user = await _db!.createUser(
        username: username,
        email: email,
        password: password,
      );

      if (user == null) {
        return AuthResult.error('Failed to create account');
      }

      // Automatically log in after signup
      return await signIn(email: email, password: password);
    } catch (e) {
      return AuthResult.error('An error occurred: $e');
    }
  }

  // Sign in with email and password
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    await _ensureInitialized();

    try {
      // Validate input
      if (email.isEmpty) {
        return AuthResult.error('Email is required');
      }
      if (password.isEmpty) {
        return AuthResult.error('Password is required');
      }

      // Authenticate user
      final result = await _db!.authenticateUser(
        email: email,
        password: password,
      );

      if (result == null) {
        return AuthResult.error('Invalid email or password');
      }

      // Save session
      _currentSessionToken = result['session_token'];
      _currentUser = result;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('session_token', _currentSessionToken!);

      return AuthResult.success(result);
    } catch (e) {
      return AuthResult.error('An error occurred: $e');
    }
  }

  // Sign in with Google
  Future<AuthResult> signInWithGoogle({
    required String googleUserId,
    required String email,
    String? displayName,
  }) async {
    await _ensureInitialized();

    try {
      final result = await _db!.createOrLinkOAuthUser(
        providerName: 'google',
        providerUserId: googleUserId,
        email: email,
        username: displayName,
      );

      if (result == null) {
        return AuthResult.error('Failed to sign in with Google');
      }

      // Save session
      _currentSessionToken = result['session_token'];
      _currentUser = result;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('session_token', _currentSessionToken!);

      return AuthResult.success(result);
    } catch (e) {
      return AuthResult.error('An error occurred: $e');
    }
  }

  // Sign in with Facebook
  Future<AuthResult> signInWithFacebook({
    required String facebookUserId,
    required String email,
    String? displayName,
  }) async {
    await _ensureInitialized();

    try {
      final result = await _db!.createOrLinkOAuthUser(
        providerName: 'facebook',
        providerUserId: facebookUserId,
        email: email,
        username: displayName,
      );

      if (result == null) {
        return AuthResult.error('Failed to sign in with Facebook');
      }

      // Save session
      _currentSessionToken = result['session_token'];
      _currentUser = result;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('session_token', _currentSessionToken!);

      return AuthResult.success(result);
    } catch (e) {
      return AuthResult.error('An error occurred: $e');
    }
  }

  // Logout
  Future<void> logout() async {
    if (_currentSessionToken != null && _db != null) {
      await _db!.logout(_currentSessionToken!);
    }

    _currentSessionToken = null;
    _currentUser = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_token');
  }

  // Request password reset
  Future<AuthResult> requestPasswordReset(String email) async {
    await _ensureInitialized();

    try {
      if (email.isEmpty) {
        return AuthResult.error('Email is required');
      }

      final token = await _db!.createPasswordResetToken(email);

      if (token == null) {
        return AuthResult.error('Email not found');
      }

      // In production, send email with reset token
      // For now, just return success with token (for testing)
      return AuthResult.success({
        'message': 'Password reset email sent',
        'reset_token': token, // Remove this in production
      });
    } catch (e) {
      return AuthResult.error('An error occurred: $e');
    }
  }

  // Reset password with token
  Future<AuthResult> resetPassword({
    required String resetToken,
    required String newPassword,
  }) async {
    await _ensureInitialized();

    try {
      if (newPassword.length < 6) {
        return AuthResult.error('Password must be at least 6 characters');
      }

      final success = await _db!.resetPasswordWithToken(
        resetToken: resetToken,
        newPassword: newPassword,
      );

      if (!success) {
        return AuthResult.error('Invalid or expired reset token');
      }

      return AuthResult.success({'message': 'Password reset successful'});
    } catch (e) {
      return AuthResult.error('An error occurred: $e');
    }
  }

  // Change password (for logged in users)
  Future<AuthResult> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await _ensureInitialized();

    try {
      if (_currentUser == null) {
        return AuthResult.error('Not logged in');
      }

      if (newPassword.length < 6) {
        return AuthResult.error('Password must be at least 6 characters');
      }

      final success = await _db!.changePassword(
        userId: _currentUser!['user_id'],
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      if (!success) {
        return AuthResult.error('Incorrect current password');
      }

      return AuthResult.success({'message': 'Password changed successfully'});
    } catch (e) {
      return AuthResult.error('An error occurred: $e');
    }
  }

  // Update user profile
  Future<AuthResult> updateProfile({String? username, String? email}) async {
    await _ensureInitialized();

    try {
      if (_currentUser == null) {
        return AuthResult.error('Not logged in');
      }

      if (email != null && !_isValidEmail(email)) {
        return AuthResult.error('Invalid email format');
      }

      final success = await _db!.updateUser(
        userId: _currentUser!['user_id'],
        username: username,
        email: email,
      );

      if (!success) {
        return AuthResult.error('Failed to update profile');
      }

      // Refresh current user data
      if (_currentSessionToken != null) {
        _currentUser = await _db!.validateSession(_currentSessionToken!);
      }

      return AuthResult.success({'message': 'Profile updated successfully'});
    } catch (e) {
      return AuthResult.error('An error occurred: $e');
    }
  }

  // Email validation helper
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

// Auth result class
class AuthResult {
  final bool success;
  final String? error;
  final Map<String, dynamic>? data;

  AuthResult._({required this.success, this.error, this.data});

  factory AuthResult.success(Map<String, dynamic> data) {
    return AuthResult._(success: true, data: data);
  }

  factory AuthResult.error(String message) {
    return AuthResult._(success: false, error: message);
  }
}
