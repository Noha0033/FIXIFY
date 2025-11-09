import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:handy_hub/core/Views/Widgets/Custom_TextFiled.dart';

import '../../ViewModels/Auth/Auth_cubit.dart';
import 'package:handy_hub/core/ViewModels/Auth/Auth_state.dart';

import '../Themes/app_colors.dart';


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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return   BlocConsumer<AuthCubit, AuthState>(
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
            return Center(child: CircularProgressIndicator());
          }
          return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: Stack(
                  children: [
// الخلفية
                    Container(

                      decoration: const BoxDecoration(
                       color: AppColors.primary
                      ),
                    ),

// نموذج التسجيل
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(24),

                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, -5),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "إنشاء حساب جديد",
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "انضم إلى FixiFy وابدأ استخدام خدماتنا بسهولة",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15, color: AppColors.textLight),
                                ),
                                const SizedBox(height: 24),

// الاسم الكامل
                                CustomTextField(
                                  controller: nameController,
                                  hintText: "الاسم الكامل",
                                  prefixIcon: Icons.person,
                                  borderSide: BorderSide(color:AppColors.primary),
                                ),
                                const SizedBox(height: 16),

// البريد الإلكتروني
                                CustomTextField(
                                  controller: emailController,
                                  hintText: 'البريد الإلكتروني',
                                  prefixIcon: Icons.email,
                                  keyboardType: TextInputType.emailAddress,
                                  borderSide: BorderSide(color:AppColors.primary),
                                ),
                                const SizedBox(height: 16),

// كلمة المرور
                                CustomPasswordField(
                                  controller: passwordController,
                                  hintText: 'كلمة المرور',
                                  prefixIcon: Icons.lock,
                                ),
                                const SizedBox(height: 16),

// تأكيد كلمة المرور
                                CustomPasswordField(
                                  controller: confirmPasswordController,
                                  hintText: 'تأكيد كلمة المرور',
                                  prefixIcon: Icons.lock,
                                  confirmWith: passwordController,
                                ),
                                const SizedBox(height: 16),

// رقم الهاتف
                                CustomTextField(
                                  controller: phoneController,
                                  hintText: 'رقم الهاتف',
                                  prefixIcon: Icons.phone,
                                  keyboardType: TextInputType.phone,
                                  borderSide: BorderSide(color:AppColors.primary),
                                ),
                                const SizedBox(height: 24),

// زر التسجيل
                                CustomButton(
                                  text: "تسجيل الحساب",
                                  onPressed: () {
                                    context.read<AuthCubit>().signUp(emailController.text, passwordController.text);

                                  },


                                ),
                                const SizedBox(height: 16),

                                GoogleButton(
                                  onPressed: () {
                                    context.read<AuthCubit>().loginByGmail();


                                  },


                                ),
                                const SizedBox(height: 16),

// رابط تسجيل الدخول
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("لديك حساب؟ "),
                                    LinkText(
                                      text: "تسجيل الدخول",
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          );
        },
    );
  }
}