import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:handy_hub/core/Repository/auth_repo.dart';
import 'package:handy_hub/core/Views/Screens/Login_Users_Screen.dart';
import 'package:handy_hub/firebase_options.dart';
import 'core/Repository/service_repository.dart';
import 'core/ViewModels/Auth/Auth_cubit.dart';
import 'core/ViewModels/onboarding/onboarding_viewmodel.dart';
import 'core/ViewModels/serviceVM/service_cubit.dart';
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
      BlocProvider(create: (_) => ServiceCubit(ServiceRepository())..fetchServices()),


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
                ? OnboardingScreen() // إذا شاهدت الواجهات مسبقًا → مباشرة Home
                : LoginScreen(), logoPath: 'assets/images/Logo finaly.png',    // أول مرة → الواجهات الترحيبية
          ),
        )
    );
  }
}
