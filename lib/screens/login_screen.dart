import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:nucleon/nucleon.dart';

import 'package:journal/screens/home_screen.dart';
import 'package:journal/widgets/pin_input.dart';
import 'package:journal/widgets/utils/j_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return JScreen(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/logo.svg",
              width: 277.0,
              height: 277.0,
              colorFilter: ColorFilter.mode(
                Theme.of(context).focusColor,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: kDefaultPadding * 2),
            PinInput(
              onComplete: (data) {
                // go home
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(data: data),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
