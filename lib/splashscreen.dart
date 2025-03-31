import 'dart:async';
import 'package:finlitapp/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();

    // Ensure navigation happens only after the current frame is drawn
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(seconds: 5), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Loginscreen()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CachedNetworkImage(
          height: 150,
          imageUrl: "https://i.pinimg.com/736x/b2/f7/9f/b2f79f2885102844f7bb9ed0b620cdd7.jpg",
          // placeholder: (context, url) => const CircularProgressIndicator(), // Loading state
          // errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red), // Error state
        ),
      ),
    );
  }
}
