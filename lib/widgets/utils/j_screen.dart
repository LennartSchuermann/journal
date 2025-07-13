import 'package:flutter/material.dart';

import 'package:journal/data.dart';

class JScreen extends StatelessWidget {
  const JScreen({super.key, required this.child, this.floatingActionButton});

  final Widget child;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: floatingActionButton,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: Padding(
        padding: const EdgeInsets.only(top: kWindowRadius * 2),
        child: child,
      ),
    );
  }
}
