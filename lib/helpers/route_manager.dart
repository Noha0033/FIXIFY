import 'package:flutter/material.dart';
import 'package:handy_hub/core/Views/Screens/Home_Screen.dart';
import 'package:handy_hub/core/Views/Screens/Login_Users_Screen.dart';

import '../core/Views/Screens/AllCraftsmansScreen.dart';
import '../core/Views/Screens/Boarding_Screen.dart';
import '../core/Views/Screens/CraftsmanDetailsScreen.dart';
import '../core/Views/Screens/Onboarding/onboarding_screen1.dart';
import '../core/Views/Screens/Splash_Screen.dart' show SplashScreen;

class RouteManager{

  static Route<dynamic>? generateRoutes(RouteSettings settings){

    switch(settings.name){
      case '/home':return MaterialPageRoute(builder: (ctx)=>HomeScreen());
      case '/login':return MaterialPageRoute(builder: (ctx)=>LoginScreen());
      case '/BoardingScreen':return MaterialPageRoute(builder: (ctx)=>BoardingScreen());
      case '/AllCraftsmanScreen':return MaterialPageRoute(builder: (ctx)=>AllCraftsmanScreen(serviceName: '', artisans: [],));
      case '/Craftsmandetailsscreen':return MaterialPageRoute(builder: (ctx)=>CraftsmanDetailsScreen());
      case '/OnboardingScreen_1':return MaterialPageRoute(builder: (ctx)=>OnboardingScreen());
      default :return MaterialPageRoute(builder: (ctx)=>HomeScreen());

    }

  }

}