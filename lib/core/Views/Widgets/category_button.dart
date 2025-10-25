import 'package:flutter/material.dart';
import '../../models/category_model.dart';
import '../Themes/app_colors.dart';

class CategoryButton extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;

  const CategoryButton({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.background,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      onPressed: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(category.iconPath, width: 40, height: 40),
          const SizedBox(height: 7),
          Text(
            category.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textDark,
              fontWeight: FontWeight.w500,
            ),
          ),

        ],
      ),
    );
  }
}
