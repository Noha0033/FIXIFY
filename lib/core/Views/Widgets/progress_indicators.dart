import 'package:flutter/material.dart';
import 'package:handy_hub/core/Views/Themes/app_colors.dart';

class ProgressIndicators extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const ProgressIndicators({super.key, required this.currentPage, required this.totalPages});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        bool isActive = currentPage == index;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          height: 8,
          width: isActive ? 24 : 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.grey.shade300,
            shape: isActive ? BoxShape.rectangle : BoxShape.circle,
            borderRadius: isActive ? BorderRadius.circular(8) : null,
          ),
        );
      }),
    );
  }
}
