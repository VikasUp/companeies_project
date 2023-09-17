import 'dart:async';
import 'package:companeies_project/provider/sign_in_provider.dart';
import 'package:companeies_project/screens/home_screen.dart';
import 'package:companeies_project/screens/login_screen.dart';
import 'package:companeies_project/screens/movie_screen.dart';
import 'package:companeies_project/util/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    final sp = context.read<SignInProvider>();
    super.initState();
    Timer(const Duration(seconds: 7), () {
      if (sp.isSignedIn == false) {
        nextScreen(context, const LoginScreen());
      } else {
        if (sp.shouldShowMovieScreen == false) {
          nextScreen(context, MovieScreen());
        } else {
          nextScreen(context, const HomeScreen());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Lottie.asset(
            'assets/Lottie_Lego.json',
            height: 150,
            width: 150,
          ),
        ),
      ),
    );
  }
}
