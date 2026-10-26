
import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Great-Grandparent
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fun Signup App',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const SignupPage(),
    );
  }
}

// Task A: AI Signup Coach
// Mock fallback because no instructor endpoint was provided.
// No live AI model is called.
class SignupTipService {
  Future<String> getTip({
    bool simulateFailure = false,
  }) async {
    // Instructor request contract:
    // {"task":"signup_tip","topic":"password_help"}
    // No personal form data is sent.

    await Future.delayed(const Duration(seconds: 1));

    if (simulateFailure) {
      throw Exception('Mock service unavailable');
    }

    return 'Use a long, unique password that you do not reuse on other accounts.';
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // The Global Key
  final _formKey = GlobalKey<FormState>();

  // Controllers to track what the user types
  final TextEditingController _nameController =
      TextEditingController();
  final TextEditingController _emailController =
      TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController();

  // Task A variables
  final SignupTipService _tipService = SignupTipService();

  bool _isLoading = false;
  bool _tipFailed = false;
  bool _simulateFailure = false;
  String _tip = '';

  // Get a signup tip
  Future<void> _getSignupTip() async {
    setState(() {
      _isLoading = true;
      _tipFailed = false;
      _tip = '';
    });

    try {
      final result = await _tipService
          .getTip(simulateFailure: _simulateFailure)
          .timeout(const Duration(seconds: 10));

      if (result.trim().isEmpty) {
        throw Exception('Empty response');
      }

      if (!mounted) return;

      final trimmed = result.trim();

      setState(() {
        _tip = trimmed.length > 240
            ? trimmed.substring(0, 240)
            : trimmed;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _tipFailed = true;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Parent
      appBar: AppBar(
        title: const Text('Join Us Today for the Cash Money!'),
        backgroundColor: Colors.purple,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),

          // Child
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Create Your Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }

                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }

                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Sign Up Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Demo signup complete — your form passed validation!',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 18),
                  ),
                ),

                const SizedBox(height: 30),

                // Task A: AI Signup Coach
                const Text(
                  'AI Signup Coach',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Mock AI advice - no live model called',
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                // Get Signup Tip Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _getSignupTip,
                  child: const Text('Get a signup tip'),
                ),

                const SizedBox(height: 10),

                // Loading State
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(),
                  ),

                // AI Result
                if (_tip.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'AI-generated advice (mock): $_tip',
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Error State and Retry
                if (_tipFailed) ...[
                  const Text(
                    'Unable to get a signup tip. Please try again.',
                    textAlign: TextAlign.center,
                  ),

                  TextButton(
                    onPressed: _isLoading ? null : _getSignupTip,
                    child: const Text('Retry'),
                  ),
                ],

                const SizedBox(height: 10),

                // Simulate offline/error for testing
                SwitchListTile(
                  title: const Text('Simulate offline/error'),
                  value: _simulateFailure,
                  onChanged: (value) {
                    setState(() {
                      _simulateFailure = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
