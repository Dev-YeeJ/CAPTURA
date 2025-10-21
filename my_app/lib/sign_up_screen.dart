import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'sign_in_screen.dart';
import 'auth_service.dart';
import 'database_helper.dart';

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF1A4D9C), Color(0xFF0C1C2E)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    path.moveTo(0, 80);
    path.quadraticBezierTo(size.width * 0.25, 20, size.width * 0.5, 40);
    path.quadraticBezierTo(size.width * 0.75, 60, size.width, 30);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class FloatingValidatorField extends StatefulWidget {
  final String label;
  final IconData prefixIcon;
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;
  final bool showVisibilityToggle;
  final String? Function(String?) validator;
  final TextInputType? keyboardType;

  const FloatingValidatorField({
    super.key,
    required this.label,
    required this.prefixIcon,
    required this.controller,
    required this.validator,
    this.obscureText = false,
    this.onToggleVisibility,
    this.showVisibilityToggle = false,
    this.keyboardType,
  });

  @override
  State<FloatingValidatorField> createState() => _FloatingValidatorFieldState();
}

class _FloatingValidatorFieldState extends State<FloatingValidatorField> {
  String? _errorMessage;
  bool _showError = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && widget.controller.text.isNotEmpty) {
      _validateField();
    } else if (!_focusNode.hasFocus && _showError) {
      setState(() {
        _showError = false;
      });
    }
  }

  void _validateField() {
    final error = widget.validator(widget.controller.text);
    if (error != null) {
      setState(() {
        _errorMessage = error;
        _showError = true;
      });
      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showError = false;
          });
        }
      });
    } else {
      setState(() {
        _showError = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.inter(
            color: const Color(0xFF374151),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
                border: _showError
                    ? Border.all(color: Colors.red.shade400, width: 1)
                    : null,
              ),
              child: TextFormField(
                controller: widget.controller,
                focusNode: _focusNode,
                obscureText: widget.obscureText,
                keyboardType: widget.keyboardType,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    widget.prefixIcon,
                    color: _showError
                        ? Colors.red.shade400
                        : const Color(0xFF6B7280),
                    size: 20,
                  ),
                  suffixIcon: widget.showVisibilityToggle
                      ? IconButton(
                          icon: Icon(
                            widget.obscureText
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: const Color(0xFF6B7280),
                            size: 20,
                          ),
                          onPressed: widget.onToggleVisibility,
                        )
                      : null,
                  hintText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: _showError
                          ? Colors.red.shade400
                          : const Color(0xFF1A4D9C),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                ),
                validator: (value) => null,
                onChanged: (value) {
                  if (_showError && value.isNotEmpty) {
                    final error = widget.validator(value);
                    if (error == null) {
                      setState(() {
                        _showError = false;
                      });
                    }
                  }
                },
              ),
            ),
            if (_showError && _errorMessage != null)
              Positioned(
                top: -8,
                right: 8,
                child: AnimatedOpacity(
                  opacity: _showError ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 200),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.shade500,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.white,
                          size: 12,
                        ),
                        SizedBox(width: 4),
                        Text(
                          _errorMessage!,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (_showError && _errorMessage != null)
              Positioned(
                top: 18,
                right: 20,
                child: AnimatedOpacity(
                  opacity: _showError ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 200),
                  child: CustomPaint(
                    size: Size(8, 6),
                    painter: TrianglePainter(Colors.red.shade500),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
        );

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _navigateToSignIn() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SignInScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Error',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Text(message, style: GoogleFonts.inter()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: GoogleFonts.inter(
                color: const Color(0xFF1A4D9C),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Success!',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Your account has been created successfully.',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToSignIn();
            },
            child: Text(
              'Continue',
              style: GoogleFonts.inter(
                color: const Color(0xFF1A4D9C),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSignUp() async {
    final usernameError = _validateUsername(_usernameController.text);
    final emailError = _validateEmail(_emailController.text);
    final passwordError = _validatePassword(_passwordController.text);
    final confirmPasswordError = _validateConfirmPassword(
      _confirmPasswordController.text,
    );

    if (usernameError != null ||
        emailError != null ||
        passwordError != null ||
        confirmPasswordError != null) {
      _showErrorDialog('Please fix all errors before signing up');
      return;
    }

    if (!_acceptTerms) {
      _showErrorDialog('Please accept the terms and conditions');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await AuthService.instance.signUp(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Print database contents to console
      await DatabaseHelper.instance.debugPrintDatabase();

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (result.success) {
        _showSuccessDialog();
      } else {
        _showErrorDialog(result.error ?? 'Failed to create account');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showErrorDialog('An unexpected error occurred: $e');
    }
  }

  Future<void> _handleGoogleSignUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _showErrorDialog('Google Sign-In not yet implemented');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleFacebookSignUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _showErrorDialog('Facebook Sign-In not yet implemented');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password required';
    }
    if (value.length < 6) {
      return 'Min 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password required';
    }
    if (value != _passwordController.text) {
      return 'Passwords don\'t match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 300,
                child: CustomPaint(
                  size: Size(double.infinity, 300),
                  painter: WavePainter(),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.asset(
                          'assets/images/captura.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A4D9C),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                  size: 35,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SizedBox(
                        height: 100,
                        child: Image.asset(
                          'assets/images/capturatextblue.png',
                          height: 25,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Text(
                              'CAPTURA',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF2D3748),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0x99D9D9D9),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  offset: const Offset(0, 4),
                                  blurRadius: 0,
                                ),
                              ],
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      'Create Your Account',
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF2D3748),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  FloatingValidatorField(
                                    label: 'Username',
                                    prefixIcon: Icons.person_outline,
                                    controller: _usernameController,
                                    validator: _validateUsername,
                                  ),
                                  const SizedBox(height: 12),
                                  FloatingValidatorField(
                                    label: 'Email',
                                    prefixIcon: Icons.mail_outline,
                                    controller: _emailController,
                                    validator: _validateEmail,
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 12),
                                  FloatingValidatorField(
                                    label: 'Password',
                                    prefixIcon: Icons.lock_outline,
                                    controller: _passwordController,
                                    validator: _validatePassword,
                                    obscureText: _obscurePassword,
                                    showVisibilityToggle: true,
                                    onToggleVisibility: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  FloatingValidatorField(
                                    label: 'Confirm Password',
                                    prefixIcon: Icons.lock_outline,
                                    controller: _confirmPasswordController,
                                    validator: _validateConfirmPassword,
                                    obscureText: _obscureConfirmPassword,
                                    showVisibilityToggle: true,
                                    onToggleVisibility: () {
                                      setState(() {
                                        _obscureConfirmPassword =
                                            !_obscureConfirmPassword;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Checkbox(
                                        value: _acceptTerms,
                                        onChanged: (value) {
                                          setState(() {
                                            _acceptTerms = value ?? false;
                                          });
                                        },
                                        activeColor: const Color(0xFF1A4D9C),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        visualDensity: VisualDensity.compact,
                                      ),
                                      Expanded(
                                        child: Text(
                                          'I accept Privacy & Term of Use',
                                          style: GoogleFonts.inter(
                                            color: const Color(0xFF374151),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 44,
                                    child: ElevatedButton(
                                      onPressed: (_acceptTerms && !_isLoading)
                                          ? _handleSignUp
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF1A4D9C,
                                        ),
                                        foregroundColor: Colors.white,
                                        disabledBackgroundColor: const Color(
                                          0xFF9CA3AF,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        elevation: 0,
                                        shadowColor: Colors.transparent,
                                      ),
                                      child: _isLoading
                                          ? SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Colors.white),
                                              ),
                                            )
                                          : Text(
                                              'Sign Up',
                                              style: GoogleFonts.inter(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: Colors.grey.shade500,
                                          thickness: 1,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        child: Text(
                                          '- OR -',
                                          style: GoogleFonts.inter(
                                            color: const Color(0xFF6B7280),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: Colors.grey.shade500,
                                          thickness: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 40,
                                    child: OutlinedButton.icon(
                                      onPressed: _isLoading
                                          ? null
                                          : _handleGoogleSignUp,
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: Color(0xFF1A4D9C),
                                          width: 2,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        backgroundColor: Colors.white
                                            .withOpacity(0.8),
                                      ),
                                      icon: Icon(
                                        Symbols.android,
                                        size: 18,
                                        color: const Color(0xFF1A4D9C),
                                      ),
                                      label: Text(
                                        'Sign up with Google',
                                        style: GoogleFonts.inter(
                                          color: const Color(0xFF1A4D9C),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 40,
                                    child: OutlinedButton.icon(
                                      onPressed: _isLoading
                                          ? null
                                          : _handleFacebookSignUp,
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: Color(0xFF1A4D9C),
                                          width: 2,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        backgroundColor: Colors.white
                                            .withOpacity(0.8),
                                      ),
                                      icon: const Icon(
                                        Icons.facebook,
                                        size: 18,
                                      ),
                                      label: Text(
                                        'Sign up with Facebook',
                                        style: GoogleFonts.inter(
                                          color: const Color(0xFF1A4D9C),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Center(
                                    child: GestureDetector(
                                      onTap: _navigateToSignIn,
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 150,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        child: RichText(
                                          text: TextSpan(
                                            text: 'Already have an Account? ',
                                            style: GoogleFonts.inter(
                                              color: const Color(0xFF000000),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: 'Sign In',
                                                style: GoogleFonts.inter(
                                                  color: const Color(
                                                    0xFF1A4D9C,
                                                  ),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
