import 'package:flutter/material.dart';
import 'package:handy_hub/core/Views/Themes/app_colors.dart';

// حقل نص عادي
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final BorderSide borderSide;
  final int? exactLength; // <-- أضفنا هذا للرقم المحدد
  final bool isRequired;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    required this.borderSide,
    this.exactLength,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textDirection: TextDirection.rtl,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFF5F7F8),
        prefixIcon: Icon(prefixIcon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'يرجى إدخال $hintText';
        }

        if (exactLength != null && value != null && value.length != exactLength) {
          return 'يجب أن يكون $hintText مكونًا من $exactLength أرقام';
        }

        return null;
      },
    );
  }
}

class CustomPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final TextEditingController? confirmWith; // للتحقق من مطابقة كلمة المرور

  const CustomPasswordField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.confirmWith,
  });

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: obscureText,
      textDirection: TextDirection.rtl,
      decoration: InputDecoration(
        hintText: widget.hintText,
        filled: true,
        fillColor: const Color(0xFFF5F7F8),
        prefixIcon: Icon(widget.prefixIcon, color: AppColors.primary),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
            color: AppColors.primary,
          ),
          onPressed: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'يرجى إدخال ${widget.hintText}';
        }

        // إذا تم تمرير confirmWith، تحقق من التطابق
        if (widget.confirmWith != null && value != widget.confirmWith!.text) {
          return 'كلمتا المرور غير متطابقتين';
        }

        return null;
      },
    );
  }
}

// أزرار وروابط كما في السابق
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color:AppColors.primary, ),

          ),
          elevation: 5,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.background,
          ),
        ),
      ),
    );
  }
}

class GoogleButton extends StatelessWidget {
  final VoidCallback onPressed;
  const GoogleButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Image.asset(
          "assets/images/google.png",
          height: 24,
          width: 24,
        ),
        label: const Text(
          "تسجيل الدخول بواسطة Google",
          style: TextStyle(
            color:AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color:AppColors.primary,),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color:AppColors.primary, ),          ),
        ),
      ),
    );
  }
}

class LinkText extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const LinkText({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
