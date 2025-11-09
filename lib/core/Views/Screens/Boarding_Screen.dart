import 'package:flutter/material.dart';
import 'package:handy_hub/core/Views/Screens/Home_Screen.dart';
import 'package:handy_hub/core/Views/Screens/Login_Users_Screen.dart';
import 'package:handy_hub/core/Views/Themes/app_colors.dart';

import '../Widgets/Custom_TextFiled.dart';
import 'AddWorkerScreen.dart';
import 'RegisterScreen.dart';


class BoardingScreen extends StatelessWidget {
  const BoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                child: SizedBox(
                  height: 150,
                  width: 250,
                ),
              ),
              Image.asset("assets/images/Logo finaly.png",),
              SizedBox(height: 20,),
              Text("خدمات حرفية موثوقة وسريعة لمنزلك",style: TextStyle(fontSize: 16,color: AppColors.text,fontWeight: FontWeight.bold),),
              SizedBox(
                height: 250,
                width: 250,
              ),
              CustomButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const HomeScreen()),
                  );                }, text: "الدخول كزائر",
              ),
              SizedBox(height: 14,),
              CustomButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const LoginScreen()),
                  );                }, text: "تسجيل الدخول",
              ),
              SizedBox(height: 14,),
              Divider(
                thickness: 1.0,          // حجم الخط
                color: Colors.grey[300],       // اللون
                indent: 4,                // المسافة من اليسار
                endIndent: 4,             // المسافة من اليمين
              ),
              SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LinkText(
                    text: "إنشاء حساب ",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SignUpScreen()),
                      );
                    },
                  ),
                  const Text("ليس لديك حساب؟ "),

                ],
              ),
            ],
          ),
        ),
      ),



    );
  }
}
