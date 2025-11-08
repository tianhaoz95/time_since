import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_since/l10n/app_localizations.dart';
import 'package:password_strength/password_strength.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  AppLocalizations? l10n;
  double _passwordStrength = 0.0;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_updatePasswordStrength);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    l10n = AppLocalizations.of(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.removeListener(_updatePasswordStrength);
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n!.passwordsMismatch)),
        );
      }
      return;
    }

    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // On successful sign-up, navigate to the home screen
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'weak-password') {
        message = l10n!.weakPassword;
      } else if (e.code == 'email-already-in-use') {
        message = l10n!.emailAlreadyInUse;
      } else {
        message = e.message ?? l10n!.unknownError;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n!.unexpectedError(e.toString()))),
        );
      }
    }
  }

  void _updatePasswordStrength() {
    setState(() {
      _passwordStrength = estimatePasswordStrength(_passwordController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            left: 20.0, // Adjust this value to move the pattern right
            top: 0.0,
            child: Image.asset(
              'assets/images/login-screen-pattern.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            top: 100,
            left: 30,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TimeSince',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  l10n!.createAccountPrompt,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.65, // Adjust this value to control height
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20.0), // Spacing from top of white section
                      Text(
                        l10n!.emailLabel,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.black),
                        autofillHints: [AutofillHints.email],
                        decoration: InputDecoration(
                          hintText: l10n!.emailHint,
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        l10n!.passwordLabel,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: _passwordController,
                        style: const TextStyle(color: Colors.black),
                        autofillHints: [AutofillHints.newPassword],
                        decoration: InputDecoration(
                          hintText: l10n!.passwordHint,
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey[400],
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_isPasswordVisible,
                      ),
                      const SizedBox(height: 8.0),
                      LinearProgressIndicator(
                        value: _passwordStrength,
                        backgroundColor: Colors.grey[300],
                        color: _passwordStrength < 0.33
                            ? Colors.red
                            : _passwordStrength < 0.66
                                ? Colors.orange
                                : Colors.green,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        _passwordStrength < 0.33
                            ? l10n!.passwordStrengthWeak
                            : _passwordStrength < 0.66
                                ? l10n!.passwordStrengthMedium
                                : l10n!.passwordStrengthStrong,
                        style: TextStyle(
                          color: _passwordStrength < 0.33
                              ? Colors.red
                              : _passwordStrength < 0.66
                                  ? Colors.orange
                                  : Colors.green,
                          fontSize: 12.0,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        l10n!.confirmPasswordLabel,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: _confirmPasswordController,
                        style: const TextStyle(color: Colors.black),
                        autofillHints: [AutofillHints.newPassword],
                        decoration: InputDecoration(
                          hintText: l10n!.confirmPasswordHint,
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey[400],
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_isConfirmPasswordVisible,
                      ),
                      const SizedBox(height: 24.0), // Adjusted spacing
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _signUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrangeAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Text(
                            l10n!.signUpButton,
                            style: const TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n!.noAccountPrompt,
                            style: const TextStyle(color: Colors.black54),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              l10n!.loginButton,
                              style: const TextStyle(color: Colors.deepOrangeAccent),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0), // Spacing at bottom of white section
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
