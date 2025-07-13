import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:nucleon/nucleon.dart';

class HomeBlankPage extends StatelessWidget {
  const HomeBlankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.rotate(
        angle: isDarkModeEnabled() ? 0.0 : math.pi,
        child: Image.asset(
          "assets/images/ellipse.png",
          width: 565.0,
          height: 565.0,
        ),
      ),
    );
  }
}
