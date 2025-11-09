import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handy_hub/core/Views/Screens/Home_Screen.dart';

import 'package:handy_hub/core/Views/Screens/RegisterScreen.dart';
import 'package:handy_hub/core/Views/Widgets/Custom_TextFiled.dart';
import '../../../helpers/firebase_auth_error_helper.dart';
import '../../ViewModels/Auth/Auth_cubit.dart';
import 'package:handy_hub/core/ViewModels/Auth/Auth_state.dart';
import '../Themes/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          // إظهار رسالة الخطأ
          FirebaseAuthErrorHelper.showSnackBar(
            context,
            FirebaseAuthException(code: state.message),
          );
        } else if (state is AuthAuthenticated) {
          // الانتقال للشاشة الرئيسية إذا تسجيل الدخول صحيح
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // الشاشة الرئيسية لتسجيل الدخول
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: AppColors.background
                    ),
                    child: Center(
                        child: Image.asset("assets/images/Logo finaly.png")
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
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
                                "مرحباً بك!",
                                style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1b3837)),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "سجّل دخولك في FixiFy",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: AppColors.textLight),
                              ),
                              const SizedBox(height: 24),
                              CustomTextField(
                                controller: emailController,
                                hintText: 'البريد الإلكتروني',
                                prefixIcon: Icons.email,
                                keyboardType: TextInputType.emailAddress,
                                borderSide: BorderSide(color: AppColors.primary),
                              ),
                              const SizedBox(height: 16),
                              CustomPasswordField(
                                controller: passwordController,
                                hintText: 'كلمة المرور',
                                prefixIcon: Icons.lock,
                              ),
                              const SizedBox(height: 24),
                              CustomButton(
                                text: "تسجيل الدخول",
                                onPressed: () {
                                  final email = emailController.text.trim();
                                  final password = passwordController.text.trim();
                                  context.read<AuthCubit>().login(email, password);
                                },
                              ),
                              const SizedBox(height: 16),
                              GoogleButton(
                                onPressed: () {
                                  context.read<AuthCubit>().loginByGmail();
                                },
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("ليس لديك حساب؟ "),
                                  LinkText(
                                    text: "إنشاء حساب جديد",
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => const SignUpScreen()),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 25),
                                CustomButton(text: "الاستمرار بدون تسجيل", onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const HomeScreen()),
                                  );
                                }),

                              const SizedBox(height: 50),


                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
