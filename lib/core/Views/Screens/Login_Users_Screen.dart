import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:handy_hub/core/Views/Screens/Sign_up_Screen.dart';
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
            FirebaseAuthErrorHelper.showSnackBar(
              context,
              FirebaseAuthException(code: state.message),
            );
          }
          if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, '/home');
          }
          else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return
            Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: Stack(
                  children: [

                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          color:AppColors.primary
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
                                      fontSize: 16,
                                      color: Color(0xFF2e5d5c),
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 24),
                                CustomTextField(
                                  controller: emailController,
                                  hintText: 'البريد الإلكتروني',
                                  prefixIcon: Icons.email,
                                  keyboardType: TextInputType.emailAddress,
                                  borderSide: BorderSide(color:AppColors.primary),
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
                                const SizedBox(height: 25),
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
            );
        },
    );
  }
}
