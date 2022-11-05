import 'dart:async';

import 'package:animated_svg/animated_svg_controller.dart';
import 'package:awecg/repository/awecg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:animated_svg/animated_svg.dart';

import '../repository/logo.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Define an SvgController

  late Timer timer;
  double time = 0;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        time += 0.01;
      });
      if (time >= 4.2) {
        timer.cancel();
        Navigator.pushReplacementNamed(context, '/init');
        //Navigator.popAndPushNamed(context, '/init');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CustomPaint(
          painter: Awecg(time),
          child: Container(
            color: Colors.transparent,
            width: width > height ? height : width,
            height: width > height ? height : width,
          ),
        ),
      ),
    );
  }
}
