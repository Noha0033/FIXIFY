import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handy_hub/core/Views/Themes/app_colors.dart';

import '../../ViewModels/serviceVM/service_cubit.dart';
import '../../ViewModels/serviceVM/service_state.dart';
import '../Widgets/service_tile.dart';


class HomeScreenCategories extends StatelessWidget {
  const HomeScreenCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text("خدماتنا", style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: BlocBuilder<ServiceCubit, ServiceState>(
          builder: (context, state) {
            if (state is ServiceLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ServiceLoaded) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  itemCount: state.services.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, index) {
                    final s = state.services[index];
                    return ServiceTile(
                      title: s.title,
                      image: s.image,
                      color: Color(s.color),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('تم اختيار ${s.title}')),
                        );
                      },
                    );
                  },
                ),
              );
            } else if (state is ServiceError) {
              return Center(child: Text(state.message));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
