import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main_navigation.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool isLoading = false;

  Widget buildInput({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
    bool isConfirm = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword
          ? (isConfirm ? hideConfirmPassword : hidePassword)
          : false,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.black54),
        filled: true,
        fillColor: const Color.fromARGB(120, 255, 255, 255),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            isConfirm
                ? (hideConfirmPassword
                ? Icons.visibility_off
                : Icons.visibility)
                : (hidePassword
                ? Icons.visibility_off
                : Icons.visibility),
          ),
          onPressed: () {
            setState(() {
              if (isConfirm) {
                hideConfirmPassword = !hideConfirmPassword;
              } else {
                hidePassword = !hidePassword;
              }
            });
          },
        )
            : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }

        if (hint == "Email" && !value.contains('@')) {
          return 'Enter valid email';
        }

        if (hint == "Password" && value.length < 6) {
          return 'Password must be at least 6 characters';
        }

        if (isConfirm && value != passwordController.text) {
          return 'Passwords do not match';
        }

        return null;
      },
    );
  }

  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigation()),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Registration failed';

      if (e.code == 'email-already-in-use') {
        message = 'This email is already used';
      } else if (e.code == 'weak-password') {
        message = 'Password is too weak';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/imgs/loading photo.png',
            fit: BoxFit.cover,
          ),

          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(170, 127, 48, 136),
                  Color.fromARGB(120, 216, 185, 209),
                  Color.fromARGB(190, 16, 23, 47),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),

          Center(
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color.fromARGB(40, 255, 255, 255),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color.fromARGB(120, 255, 255, 255),
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "AROMA",
                      style: TextStyle(
                        fontSize: 32,
                        letterSpacing: 4,
                        color: Color(0xFF25113D),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Create Account",
                      style: TextStyle(fontSize: 13),
                    ),

                    const SizedBox(height: 25),

                    buildInput(
                      hint: "Full Name",
                      icon: Icons.person_outline,
                      controller: nameController,
                    ),

                    const SizedBox(height: 12),

                    buildInput(
                      hint: "Email",
                      icon: Icons.email_outlined,
                      controller: emailController,
                    ),

                    const SizedBox(height: 12),

                    buildInput(
                      hint: "Password",
                      icon: Icons.lock_outline,
                      controller: passwordController,
                      isPassword: true,
                    ),

                    const SizedBox(height: 12),

                    buildInput(
                      hint: "Confirm Password",
                      icon: Icons.lock_outline,
                      controller: confirmPasswordController,
                      isPassword: true,
                      isConfirm: true,
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF08122F),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: isLoading ? null : registerUser,
                        child: isLoading
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : const Text("REGISTER"),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(fontSize: 11),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Color(0xFF08122F),
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