import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'sign_up_screen.dart';
import 'auth_service.dart';
import 'database_helper.dart';
import 'home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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

  void _navigateToSignUp() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SignUpScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
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

  void _navigateToHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  Future<void> _handleSignIn() async {
    final emailError = _validateEmail(_emailController.text);
    final passwordError = _validatePassword(_passwordController.text);

    if (emailError != null || passwordError != null) {
      _showErrorDialog('Please fix all errors before signing in');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await AuthService.instance.signIn(
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
        _navigateToHome();
      } else {
        _showErrorDialog(result.error ?? 'Failed to sign in');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showErrorDialog('An unexpected error occurred: $e');
    }
  }

  Future<void> _handleGoogleSignIn() async {
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

  Future<void> _handleFacebookSignIn() async {
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

  Future<void> _handleForgotPassword() async {
    final emailController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Forgot Password',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your email address to receive a password reset link.',
              style: GoogleFonts.inter(fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Send Reset Link',
              style: GoogleFonts.inter(
                color: const Color(0xFF1A4D9C),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (result == true && emailController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        final authResult = await AuthService.instance.requestPasswordReset(
          emailController.text.trim(),
        );

        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

        if (authResult.success) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                'Email Sent',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              content: Text(
                'Password reset instructions have been sent to your email.',
                style: GoogleFonts.inter(),
              ),
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
        } else {
          _showErrorDialog(authResult.error ?? 'Failed to send reset email');
        }
      } catch (e) {
        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

        _showErrorDialog('An unexpected error occurred: $e');
      }
    }
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
                  size: const Size(double.infinity, 300),
                  painter: WavePainter(),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset(
                          'assets/images/captura.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 100,
                              height: 100,
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
                    const SizedBox(height: 15),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Image.asset(
                        'assets/images/capturatextblue.png',
                        height: 33,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Text(
                            'CAPTURA',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF2D3748),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                            ),
                          );
                        },
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(height: 20),
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
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
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Center(
                                  child: Text(
                                    'Enter Your Account',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF2D3748),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
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
                                const SizedBox(height: 6),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: _handleForgotPassword,
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      'Forgot Password?',
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF6B7280),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                SizedBox(
                                  width: double.infinity,
                                  height: 44,
                                  child: ElevatedButton(
                                    onPressed: _isLoading
                                        ? null
                                        : _handleSignIn,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1A4D9C),
                                      foregroundColor: Colors.white,
                                      disabledBackgroundColor: const Color(
                                        0xFF9CA3AF,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                      shadowColor: Colors.transparent,
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                        : Text(
                                            'Log In',
                                            style: GoogleFonts.inter(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 10),
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
                                        horizontal: 10,
                                      ),
                                      child: Text(
                                        '- OR -',
                                        style: GoogleFonts.inter(
                                          color: const Color(0xFF6B7280),
                                          fontSize: 11,
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
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  height: 44,
                                  child: OutlinedButton.icon(
                                    onPressed: _isLoading
                                        ? null
                                        : _handleGoogleSignIn,
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: Color(0xFFE5E7EB),
                                        width: 1,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      backgroundColor: Colors.white,
                                    ),
                                    icon: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: Image.network(
                                        'https://cdn.cdnlogo.com/logos/g/35/google-icon.svg',
                                        width: 20,
                                        height: 20,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return const Icon(
                                                Symbols.android,
                                                size: 20,
                                                color: Color(0xFF4285F4),
                                              );
                                            },
                                      ),
                                    ),
                                    label: Text(
                                      'Log in with Google',
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF374151),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  height: 44,
                                  child: OutlinedButton.icon(
                                    onPressed: _isLoading
                                        ? null
                                        : _handleFacebookSignIn,
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: Color(0xFFE5E7EB),
                                        width: 1,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      backgroundColor: Colors.white,
                                    ),
                                    icon: const Icon(
                                      Icons.facebook,
                                      size: 20,
                                      color: Color(0xFF1877F2),
                                    ),
                                    label: Text(
                                      'Log in with Facebook',
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF374151),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Center(
                                  child: GestureDetector(
                                    onTap: _navigateToSignUp,
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
                                          text: 'Not have an Account? ',
                                          style: GoogleFonts.inter(
                                            color: const Color(0xFF000000),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: 'Sign Up',
                                              style: GoogleFonts.inter(
                                                color: const Color(0xFF1A4D9C),
                                                fontSize: 12,
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
                    const SizedBox(height: 20),
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

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [const Color(0xFF1A4D9C), const Color(0xFF0C1C2E)],
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
