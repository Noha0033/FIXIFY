import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handy_hub/core/Views/Screens/Login_Users_Screen.dart';
import '../../ViewModels/Auth/Auth_cubit.dart';
import '../../ViewModels/Auth/Auth_state.dart';
import '../Themes/app_colors.dart';
import '../Widgets/CraftsmanFields.dart';
import '../Widgets/Custom_TextFiled.dart';
import '../Widgets/CustomerFields.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController companyController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isCraftsman = false;

  Widget userTypeToggle() {
    return Container(
      padding: const EdgeInsets.all(3),
     // margin: const EdgeInsets.symmetric(vertical:0 ,horizontal: 20) ,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => setState(() => isCraftsman = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              decoration: BoxDecoration(
                color: !isCraftsman ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                'مستخدم',
                style: TextStyle(
                  fontSize: 16,
                  color: !isCraftsman ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => isCraftsman = true),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              decoration: BoxDecoration(
                color: isCraftsman ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                'حرفي',
                style: TextStyle(
                  fontSize: 16,
                  color: isCraftsman ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        )
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "إنشاء حساب جديد",
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textDark),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "انضم إلى FixiFy وابدأ استخدام خدماتنا بسهولة",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, color: AppColors.textLight),
                          ),
                          const SizedBox(height: 20),
                          userTypeToggle(),
                          const SizedBox(height: 20),

                          // الحقول حسب النوع
                          CustomerFields(
                            nameController: nameController,
                            emailController: emailController,
                            passwordController: passwordController,
                            confirmPasswordController: confirmPasswordController,
                            phoneController: phoneController,
                          ),
                          if (isCraftsman)
                            CraftsmanFields(
                              professionController: professionController,
                             companyController: companyController,
                            ),

                          CustomButton(
                            text: "تسجيل الحساب",
                            onPressed: () {},
                          ),
                          const SizedBox(height: 16),
                          GoogleButton(onPressed: () { context.read<AuthCubit>().loginByGmail(); }),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("لديك حساب؟ ", style: TextStyle(fontSize: 14)),
                              LinkText(text: "تسجيل الدخول", onTap: () =>  Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()),
                              )),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      )

                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
