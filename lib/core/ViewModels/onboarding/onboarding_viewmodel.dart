import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../storage/storage_keys.dart';
import 'OnboardingState.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingState(currentPage: 0));

  // إضافة PageController
  final PageController pageController = PageController();

  // تحديث الصفحة عند السحب
  void updatePage(int index) {
    emit(OnboardingState(currentPage: index));
  }

  void nextPage(BuildContext context, int totalPages) {
    if (state.currentPage < totalPages - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      completeOnboarding(context);
    }
  }

  void completeOnboarding(BuildContext context) {
    AppStorage.setOnboardingShown();
    Navigator.pushReplacementNamed(context, '/home');
  }
}
