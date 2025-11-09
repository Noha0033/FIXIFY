import 'package:flutter/material.dart';

import '../Themes/app_colors.dart';
import 'Custom_TextFiled.dart';

class CustomerFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController phoneController;

  const CustomerFields({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          CustomTextField(
            controller: nameController,
            hintText: "الاسم الكامل",
            prefixIcon: Icons.person,
            borderSide: BorderSide(color: AppColors.primary, width: 1),
          ),
          const SizedBox(height: 14),
          CustomTextField(
            controller: emailController,
            hintText: 'البريد الإلكتروني',
            prefixIcon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            borderSide: BorderSide(color: AppColors.primary, width: 1),
          ),
          const SizedBox(height: 14),
          CustomPasswordField(
            controller: passwordController,
            hintText: 'كلمة المرور',
            prefixIcon: Icons.lock,
          ),
          const SizedBox(height: 14),
          CustomPasswordField(
            controller: confirmPasswordController,
            hintText: 'تأكيد كلمة المرور',
            prefixIcon: Icons.lock,
            confirmWith: passwordController,
          ),
          const SizedBox(height: 14),
          CustomTextField(
            controller: phoneController,
            hintText: 'رقم الهاتف',
            prefixIcon: Icons.phone,
            keyboardType: TextInputType.phone,
            borderSide: BorderSide(color: AppColors.primary, width: 1),
            exactLength: 9,
          ),
        ],
      ),
    );
  }
}
