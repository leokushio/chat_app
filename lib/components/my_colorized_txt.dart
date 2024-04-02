import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class MyColorizedTxt extends StatelessWidget {
  final String text;
  final Function()? onTap;
  const MyColorizedTxt({
    super.key,
    required this.text,
    required this.onTap
    });

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      onTap: onTap,
      pause: Duration.zero,
      totalRepeatCount: 1,
      animatedTexts: [
        ColorizeAnimatedText(text,
            textStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            colors: [
              Colors.blue,
              Colors.purpleAccent,
              Colors.blueAccent,
            ],
            speed: const Duration(seconds: 1))
      ]);
  }
}
