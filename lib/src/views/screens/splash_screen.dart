// ignore_for_file: use_build_context_synchronously

import 'package:decider_app/src/core/constants/app_route_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
     _checkAuth(context);
    return  Scaffold(
      body:  Center(
        child:  SvgPicture.asset("assets/svg/d.svg"
        ),
      ),
    );
  }

  void _checkAuth(BuildContext context) async {
    await Future.delayed(
        const Duration(milliseconds: 2000)); // Simulate a delay for the splash screen

      Navigator.pushNamedAndRemoveUntil(
          context, RouteConstants.deciderListScreen, (route) => false);
  }
}



