import 'dart:async';
import 'package:flutter/material.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 4), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
       MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [

          // الخلفية على كامل الصفحة
          Image.asset(
            'assets/images/perfume2.png',
            fit: BoxFit.cover,
          ),

          // طبقة تغميق خفيفة
          Container(
            color: Colors.black.withValues(alpha: 0.2),
          ),

          // العنوان
          Positioned(
            top: 90,
            left: 0,
            right: 0,
            child: Column(
              children: const [
                Text(
                  "AMORA",
                  style: TextStyle(
                    fontSize: 55,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 10,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "DISCOVER YOUR SIGNATURE SCENT",
                  style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 3,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // النص السفلي
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Text(
                  "Luxury Perfume Collection",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: 220,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: const LinearProgressIndicator(
                      minHeight: 5,
                      backgroundColor: Colors.white54,
                      color: Color(0xFFE58AC0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}