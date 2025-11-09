import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:handy_hub/core/Repository/auth_repo.dart';
import 'package:handy_hub/core/ViewModels/SearchCubit/SearchCubitVM.dart';
import 'package:handy_hub/firebase_options.dart';
import 'core/Repository/LocationService.dart';
import 'core/ViewModels/Auth/Auth_cubit.dart';
import 'core/ViewModels/Location_google/LocationCubit.dart';
import 'core/ViewModels/onboarding/onboarding_viewmodel.dart';
import 'core/Views/Screens/Boarding_Screen.dart';
import 'core/Views/Screens/Home_Screen.dart';
import 'core/Views/Screens/Onboarding/onboarding_screen1.dart';
import 'core/Views/Screens/Splash_Screen.dart';
import 'core/Views/Themes/app_colors.dart' show AppColors;
import 'core/storage/storage_keys.dart';
import 'helpers/route_manager.dart';


void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform);
  runApp(Handy_Hub());

}
class Handy_Hub extends StatelessWidget {

  final AuthRepository authRepository = AuthRepository();
  Handy_Hub({super.key});

  @override
  Widget build(BuildContext context) {
    final bool showOnboarding = !AppStorage.isOnboardingShown();
    return MultiBlocProvider(providers: [
      BlocProvider(create: (ctx)=>AuthCubit(authRepository)),
      BlocProvider(create: (ctx)=>OnboardingCubit()),
      BlocProvider(create: (ctx)=>SearchCubit()),
      BlocProvider(
        create: (_) => LocationCubit(LocationService()),
      ),



    ],
        child: MaterialApp(
          title: "HandyHub",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: AppColors.primary,
            fontFamily: 'Cairo',
          ),
          onGenerateRoute: RouteManager.generateRoutes,
          home: SplashScreen(
            nextScreen: showOnboarding
                ? HomeScreen()          // إذا شاهد الواجهات من قبل → مباشرة إلى الصفحة الرئيسية
                : OnboardingScreen(),   // أول مرة → يعرض شاشة الترحيب
            logoPath: 'assets/images/Logo finaly.png',
          ),

        )
    );
  }
}
