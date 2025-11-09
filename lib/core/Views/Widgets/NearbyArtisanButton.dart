import 'package:flutter/material.dart';
import 'package:handy_hub/core/Views/Themes/app_colors.dart';

class NearbyArtisanButton extends StatelessWidget {
  final VoidCallback onPressed;
  const NearbyArtisanButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25),
        side: BorderSide(color: Colors.white54)),
        minimumSize: const Size.fromHeight(45),
      ),
      onPressed: onPressed,
      icon: const Icon(Icons.location_on,color: AppColors.background,),
      label: const Text('اكتشف الحرفيين الأقرب لك',style: TextStyle(color: AppColors.background),),
    );
  }
}
