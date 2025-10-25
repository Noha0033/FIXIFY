import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handy_hub/core/Views/Themes/app_colors.dart';

import '../../ViewModels/homeVM/home_cubit.dart';
import '../../ViewModels/homeVM/home_state.dart';
import '../widgets/category_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // من اليمين إلى اليسار
      child: BlocProvider(
        create: (_) => HomeCubit()..loadCategories(),
        child: Scaffold(

          backgroundColor: AppColors.primary,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [


                      const SizedBox(height: 3),
                      TextField(
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: "ما الخدمة التي تبحث عنها؟",
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(45),
                            //borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Banner



                ])),
                  SizedBox(height: 8),
                  Expanded(
                    child: BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        return Container(
                          height: double.infinity,
                          width: double.infinity,
                          color: Colors.grey[200],
                          padding: EdgeInsetsGeometry.all(8.0),
                          child: GridView.builder(
                            itemCount: state.categories.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                            itemBuilder: (context, index) {
                              return CategoryButton(
                                category: state.categories[index],
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("تم اختيار ${state.categories[index].title}"),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),

              ],
            ),


          ),

          bottomNavigationBar: BottomNavigationBar(
            currentIndex: 0,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "الرئيسية"),
              BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "طلباتي"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "حسابي"),
            ],
          ),
        ),
      ),
    );
  }
}
