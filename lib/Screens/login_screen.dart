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

  void _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields', style: text),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }


    // Get email from your TextEditingController
    final email = _emailController.text.trim();

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.orange),
      ),
    );

    try {
      // Call your backend API
      bool success = await ApiService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      // Hide loading
      Navigator.pop(context);

      if (success) {
        // Login successful - navigate to home
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(User(
        username: email.split('@').first, // Get this from your API response
        email: email,
      ));
      
      if (context.mounted) {
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => HomeScreen())
        );
      }
      } else {
        // Login failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid email or password', style: text),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Hide loading
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connection error: $e', style: text),
          backgroundColor: Colors.red,
        ),
      );
    }
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

            Padding(
              padding: const EdgeInsets.all(30),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      //logo
                      Image.asset(
                        'assets/login/logo.png',
                        width: 100,
                        height: 100,
                      ),

                      const SizedBox(height: 10),

                      Text("PICK MY DISH", style: title),

                      Text("Cook in easy way", style: text),

                      const SizedBox(height: 5),

                      Text("Login", style: title),

                      const SizedBox(height: 15),

                      Row(
                        children: [
                          const Icon(
                            Icons.email,
                            color: Colors.white,
                            size: iconSize,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _emailController,
                              style: text,
                              decoration: InputDecoration(
                                hintText: "Email Address",
                                hintStyle: placeHolder,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Row(
                        children: [
                          const Icon(
                            Icons.key,
                            color: Colors.white,
                            size: iconSize,
                          ),
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
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Forgot password logic
                            },
                            child: Text(
                              "Forgot Password? ",
                              style: footerClickable,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      // Add this after the Login Button and before Google Sign In

// TEST BUTTONS - Remove these later
Row(
  children: [
    Expanded(
      child: ElevatedButton(
        onPressed: _testRegistration,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          minimumSize: const Size(0, 40),
        ),
        child: Text("Test Register", style: text.copyWith(fontSize: 14)),
      ),
    ),
    const SizedBox(width: 10),
    Expanded(
      child: ElevatedButton(
        onPressed: _testLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          minimumSize: const Size(0, 40),
        ),
        child: Text("Test Login", style: text.copyWith(fontSize: 14)),
      ),
    ),
  ],
),

const SizedBox(height: 20),
// END TEST BUTTONS
                      // Google Sign In
                      GestureDetector(
                        onTap: () {
                          // Google sign in logic
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
                      ElevatedButton(
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

void _testRegistration() async {
  debugPrint('🔐 Testing registration...');
  
  try {
    bool success = await ApiService.register(
      'user1', 
      'user1@example.com', 
      'passwffdfd23'
    );
    
    if (success) {
      debugPrint('✅ Registration successful!');
    } else {
      debugPrint('❌ Registration failed - check backend logs');
    }
  } catch (e) {
    debugPrint('❌ Registration error: $e');
  }
}

void _testLogin() async {
  debugPrint('🔐 Testing login...');
  
  try {
    bool success = await ApiService.login('Jane@example.com', 'password123');
    
    if (success) {
      debugPrint('✅ Login successful!');
    } else {
      debugPrint('❌ Login failed - user may not exist');
    }
  } catch (e) {
    debugPrint('❌ Login error: $e');
  }
}

}
