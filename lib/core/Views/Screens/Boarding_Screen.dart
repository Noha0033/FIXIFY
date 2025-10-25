import 'package:flutter/material.dart';
import 'package:handy_hub/core/Views/Screens/Home_Screen.dart';
import 'package:handy_hub/core/Views/Screens/Login_Users_Screen.dart';
import 'package:handy_hub/core/Views/Themes/app_colors.dart';

import '../Widgets/Custom_TextFiled.dart';
import 'AddWorkerScreen.dart';


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
                  height: 200,
                  width: 250,
                ),
              ),
              Image.asset("assets/images/Logo finaly.png",),
              SizedBox(height: 20,),
              Text("خدمات حرفية موثوقة وسريعة لمنزلك",style: TextStyle(fontSize: 16,color: AppColors.text,fontWeight: FontWeight.bold),),
              SizedBox(
                height: 300,
                width: 250,
              ),
              CustomButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const HomeScreen()),
                  );                }, text: "ابحث عن عامل",
              ),
              SizedBox(height: 14,),
              CustomButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AddWorkerScreen()),
                  );                }, text: "أنا عامل",
              )
            ],
          ),
        ),
      ),



    );
  }
}
