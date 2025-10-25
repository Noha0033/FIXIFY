import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Models/OnboardingPageModel.dart';
import '../../../ViewModels/onboarding/OnboardingState.dart';
import '../../../ViewModels/onboarding/onboarding_viewmodel.dart';
import '../../Widgets/next_button.dart';
import '../../Widgets/onboarding_image.dart';
import '../../Widgets/onboarding_texts.dart';
import '../../Widgets/progress_indicators.dart';
import '../../Widgets/skip_button.dart';

class OnboardingScreen extends StatelessWidget {
   OnboardingScreen({super.key});

  final List<OnboardingPageModel> onboardingPages = [
    OnboardingPageModel(
      imagePath: 'assets/images1/1.png',
      title: 'ابحث عن خبراء موثوق بهم',
      description: 'العثور على الأشخاص الأكثر خبرة وثقة لمساعدتك',
    ),
    OnboardingPageModel(
      imagePath: 'assets/images1/2.png', // الصورة اللي أرفقتها
      title: 'جدول طريقك',
      description: 'جدولة الخدمة الخاصة بك في الوقت المناسب لك',
    ),
    OnboardingPageModel(
      imagePath: 'assets/images1/3.png', // الصورة اللي أرفقتها
      title: 'ابق على اتصال',
      description: 'الدردشة أو الاتصال بمنفذ المهمة الخاص بك لضبط كل التفاصيل',
    ),
  ];



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: BlocBuilder<OnboardingCubit, OnboardingState>(
        builder: (context, state) {
          final cubit = context.read<OnboardingCubit>();
          final currentPageData = onboardingPages[state.currentPage];

          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SkipButton(onPressed: () => cubit.completeOnboarding(context)),
                  Expanded(
                    child: PageView.builder(
                      itemCount: onboardingPages.length,
                      controller: cubit.pageController, // تضيف PageController في Cubit
                      onPageChanged: (index) => cubit.updatePage(index),
                      itemBuilder: (context, index) {
                        final page = onboardingPages[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Images(imagePath: page.imagePath),
                              OnboardingTexts(
                                title: page.title,
                                description: page.description,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  ProgressIndicators(currentPage: state.currentPage, totalPages: onboardingPages.length),
                  NextButton(
                    onPressed: () => cubit.nextPage(context, onboardingPages.length),
                    isLastPage: state.currentPage == onboardingPages.length - 1,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
