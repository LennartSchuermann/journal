import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';

import 'package:nucleon/nucleon.dart';
import 'package:nucleon/nucleon_widgets.dart';

import 'package:journal/data.dart';
import 'package:journal/screens/home_screen.dart';
import 'package:journal/widgets/utils/j_screen.dart';
import 'package:journal/widgets/utils/pin_code_themes.dart';
import 'package:journal/screens/controller/login_screen_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginScreenController loginScreenController;
  late PinTheme defaultPT;

  @override
  void initState() {
    super.initState();
    loginScreenController = LoginScreenController();
  }

  @override
  Widget build(BuildContext context) {
    defaultPT = defaultPinTheme(context);
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
            Pinput(
              defaultPinTheme: defaultPT,
              focusedPinTheme: focusedPinTheme(
                context,
                defaultPinTheme: defaultPT,
              ),
              submittedPinTheme: submittedPinTheme(
                context,
                defaultPinTheme: defaultPT,
              ),
              validator: (s) => null,
              obscureText: true,
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              showCursor: false,
              onCompleted: (pin) async {
                bool loadSuccessful = await loginScreenController.load(pin);

                if (!loadSuccessful && context.mounted) {
                  nShowToast(
                    context,
                    title: "Incorrect Pin Code",
                    description: "",
                    type: ToastType.error,
                    widthOverride: getToastWidth(context),
                  );
                } else if (loadSuccessful && context.mounted) {
                  // go home
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                }
              },
            ),
            loginScreenController.firstAppUse
                ? Padding(
                    padding: const EdgeInsets.only(top: kDefaultPadding),
                    child: NContentFont(
                      "Welcome to ${kAppData.appName}! Set a password to get started.",
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
