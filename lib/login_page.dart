import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_page.dart';
import 'main_navigation.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool hidePassword = true;
  bool isLoading = false;

  Future<void> loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful')),
      );

      // هون حطي صفحة الهوم لما تجهزيها
       Navigator.pushReplacement(
         context,
         MaterialPageRoute(builder: (context) => const MainNavigation()),
       );

    } on FirebaseAuthException catch (e) {
      String message = 'Login failed';

      if (e.code == 'user-not-found') {
        message = 'No user found with this email';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email';
      } else if (e.code == 'invalid-credential') {
        message = 'Email or password is wrong';
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  Widget buildInput({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? hidePassword : false,
      style: const TextStyle(fontSize: 12, color: Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 11, color: Colors.black54),
        prefixIcon: Icon(icon, size: 16, color: Colors.black54),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            hidePassword ? Icons.visibility_off : Icons.visibility,
            size: 16,
            color: Colors.black45,
          ),
          onPressed: () {
            setState(() {
              hidePassword = !hidePassword;
            });
          },
        )
            : null,
        filled: true,
        fillColor: const Color.fromARGB(90, 255, 255, 255),
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $hint';
        }

        if (hint == 'Email' && !value.contains('@')) {
          return 'Enter valid email';
        }

        return null;
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/imgs/loading photo.png'),
                fit: BoxFit.cover,
              ),
            ),
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
            child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Container(
              width: 280,
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 32,
                bottom: 28,
              ),
              decoration: BoxDecoration(
                color: const Color.fromARGB(45, 255, 255, 255),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color.fromARGB(120, 255, 255, 255),
                  width: 1,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 25,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'AROMA',
                      style: TextStyle(
                        fontSize: 34,
                        letterSpacing: 5,
                        color: Color(0xFF25113D),
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 25),

                    buildInput(
                      hint: 'Email',
                      icon: Icons.email_outlined,
                      controller: emailController,
                    ),

                    const SizedBox(height: 14),

                    buildInput(
                      hint: 'Password',
                      icon: Icons.lock_outline,
                      controller: passwordController,
                      isPassword: true,
                    ),

                    const SizedBox(height: 4),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF08122F),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          elevation: 0,
                        ),
                        onPressed: isLoading ? null : loginUser,
                        child: isLoading
                            ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : const Text(
                          'LOGIN',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    SizedBox(
                      width: double.infinity,
                      height: 38,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                          const Color.fromARGB(70, 255, 255, 255),
                          side: const BorderSide(
                            color: Color.fromARGB(110, 255, 255, 255),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        onPressed: () {},
                        icon: const Text(
                          'G',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        label: const Text(
                          'Continue with Google',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black87,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 10,
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
          ),)
        ],
      ),
    );
  }
}