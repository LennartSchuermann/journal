import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';

import 'package:nucleon/nucleon.dart';

class HomeBlankPage extends StatelessWidget {
  const HomeBlankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.rotate(
        angle: isDarkModeEnabled() ? 0.0 : math.pi,
        child:
            Image.asset(
              "assets/images/ellipse.png",
              width: 565.0,
              height: 565.0,
            ).animate().fadeIn(
              delay: Duration(milliseconds: 200),
              duration: Duration(milliseconds: 500),
              curve: Curves.fastEaseInToSlowEaseOut,
            ),
      ),
    );
  }
}
