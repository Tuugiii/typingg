import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:diplooajil/ButtonScreen.dart';

void main() {
  runApp(const TypingMasterApp());
}

class TypingMasterApp extends StatelessWidget {
  const TypingMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;  // Default to login screen
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void toggleScreen() {
    setState(() {
      isLogin = !isLogin;  // Toggle between Login and Register screen
    });
  }

  // This function will navigate directly to the ButtonScreen when login is successful
  void handleLogin() {
    // You can add login validation here if needed
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ButtonScreen()),  // Navigate to ButtonScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(top: 0, left: 0, child: Image.asset('assets/images/main_top.png', width: 150)),
          Positioned(bottom: 0, left: 0, child: Image.asset('assets/images/main_top.png', width: 150)),
          Positioned(bottom: 0, right: 0, child: Image.asset('assets/images/login_bottom.png', width: 150)),
          
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: Lottie.asset(
                        isLogin ? 'assets/lottie/login.json' : 'assets/lottie/speed.json',
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (!isLogin) ...[ // Sign Up fields
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          hintText: "Your name",
                          filled: true,
                          fillColor: Colors.purple.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        hintText: "Your email",
                        filled: true,
                        fillColor: Colors.purple.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        hintText: "Your password",
                        filled: true,
                        fillColor: Colors.purple.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    if (!isLogin) ...[ // Password Repeat field
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          hintText: "Repeat your password",
                          filled: true,
                          fillColor: Colors.purple.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: handleLogin,  // Call the handleLogin function on press
                        child: Text(
                          isLogin ? 'LOGIN' : 'SIGN UP',
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(isLogin ? "Don't have an account? " : "Already have an account? "),
                        GestureDetector(
                          onTap: toggleScreen,  // Toggle between Login and Register screens
                          child: Text(
                            isLogin ? "Sign Up" : "Sign In",
                            style: const TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
    );
  }
}
