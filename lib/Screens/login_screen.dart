import 'package:flutter/material.dart';
import 'package:pick_my_dish/Models/user_model.dart';
import 'package:pick_my_dish/Providers/user_provider.dart';
import 'package:pick_my_dish/Services/api_service.dart';
import 'package:pick_my_dish/constants.dart';
import 'package:pick_my_dish/Screens/register_screen.dart';
import 'package:pick_my_dish/Screens/home_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;


  void _login() async {
    // Validate inputs
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields', style: text),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Show loading
    setState(() => _isLoading = true);
    
    // Get email and password
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      // Call your backend API
      final Map<String, dynamic>? response = await ApiService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      // if (response != null && response['user'] != null) {
      //   final userProvider = Provider.of<UserProvider>(context, listen: false);
        
      //   // Use the actual user data from API
      //   userProvider.setUser(User.fromJson(response['user']));
      //   userProvider.setUserId(response['userId'] ?? 0);
      //   if (context.mounted) {
      //     Navigator.pushReplacement(
      //       context, 
      //       MaterialPageRoute(builder: (context) => HomeScreen())
      //     );
      //   }
      // } else {
      //   // Handle error
      //   final errorMessage = response?['error'] ?? 'Login failed';
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //         content: Text(errorMessage, style: text),
      //         backgroundColor: Colors.red,
      //       ),
      //     );
      //   }

      if (response != null && response['user'] != null) {
        // Login successful - navigate to home
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      
      // Use the actual user data from API
      userProvider.setUser(User.fromJson(response['user']));
      // Store the user ID from login response
      userProvider.setUserId(response['userId'] ?? 0);
      
      if (context.mounted) {
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => HomeScreen())
        );
        
        // Initialize API service with token
        ApiService.setAuthToken(response['token'] ?? '');
        
        debugPrint('✅ Login successful, navigating to HomeScreen');
        
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false, // Remove all previous routes
          );
        }
      } else {
        // Login failed
        // Hide loading
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage, style: text),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Connection error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connection error: $e', style: text),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _loginAsGuest() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    // Clear any existing user data
    userProvider.clearAllUserData();
    
    // Navigate to home as guest
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/login/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Gradient overlay
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            
            // Login Form
            Padding(
              padding: const EdgeInsets.all(30),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      
                      // Logo
                      Image.asset(
                        'assets/login/logo.png',
                        width: 100,
                        height: 100,
                      ),
                      
                      const SizedBox(height: 10),
                      
                      // App Title
                      Text("PICK MY DISH", style: title),
                      Text("Cook in easy way", style: text),
                      
                      const SizedBox(height: 5),
                      Text("Login", style: title),
                      const SizedBox(height: 30),
                      
                      // Email Input
                      Row(
                        children: [
                          const Icon(Icons.email, color: Colors.white, size: iconSize),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _emailController,
                              style: text,
                              decoration: InputDecoration(
                                hintText: "Email Address",
                                hintStyle: placeHolder,
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 15),
                      
                      // Password Input
                      Row(
                        children: [
                          const Icon(Icons.key, color: Colors.white, size: iconSize),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _passwordController,
                              style: text,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: placeHolder,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 10),
                      
                      // Guest Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                              context, 
                              MaterialPageRoute(builder: (context) => HomeScreen())
                            );
                            },
                            child: Text(
                              "Login As Guest",
                              style: footerClickable,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Google Sign In (optional)
                      GestureDetector(
                        onTap: () {
                          // Google sign in logic (to be implemented)
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.g_mobiledata,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Login Button
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.orange)
                          : ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                "Login",
                                style: title.copyWith(fontSize: 20),
                              ),
                            ),
                      
                      const SizedBox(height: 20),
                      
                      // Register Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Not Registered Yet? ", style: footer),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: Text("Register Now", style: footerClickable),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
