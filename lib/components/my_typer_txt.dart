import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class MyTyperTxt extends StatelessWidget {
  final String text;
  const MyTyperTxt({
    required this.text,
    super.key
    });

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      totalRepeatCount: 1,
      animatedTexts: [
        TyperAnimatedText(
          text,
          speed: const Duration(microseconds: 50000),
          textStyle: TextStyle(
            fontSize: 20,
            color: Colors.grey.shade800
          )
        )
    ]);
  }
}