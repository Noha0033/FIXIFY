import 'package:flutter/material.dart';

class OnboardingImage extends StatelessWidget {
  final String imagePath;

  const OnboardingImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Center(
        child: Image.asset(
          imagePath,
          height: 350,
          width: double.infinity,

        ),
      ),
    );
  }
}
