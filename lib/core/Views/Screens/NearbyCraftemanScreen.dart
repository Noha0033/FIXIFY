import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Repository/CraftsmanRepository.dart';
import '../../ViewModels/NearbyCraftsman/NearbyCraftsmanCubit.dart';
import '../Themes/app_colors.dart';

class NearbyCraftsmanScreen extends StatelessWidget {
  final double latitude;
  final double longitude;

  const NearbyCraftsmanScreen({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
      NearbyCraftsmanCubit(CraftsmanRepository())..loadNearby(latitude, longitude),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("الحرفيون القريبون منك"),
          backgroundColor: AppColors.primary,
        ),
        body: BlocBuilder<NearbyCraftsmanCubit, NearbyCraftsmanState>(
          builder: (context, state) {
            if (state is NearbyLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NearbyError) {
              return Center(child: Text(state.message));
            } else if (state is NearbyLoaded) {
              final artisans = state.artisans;
              if (artisans.isEmpty) {
                return const Center(
                    child: Text("لا يوجد حرفيون ضمن نطاق 3 كيلومترات."));
              }
              return ListView.builder(
                itemCount: artisans.length,
                itemBuilder: (context, index) {
                  final artisan = artisans[index];
                  return Card(
                    margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(artisan.name),
                      subtitle: Text(
                        "${artisan.distance?.toStringAsFixed(2) ?? '--'} كم",
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/artisanDetails',
                          arguments: artisan,
                        );
                      },
                    ),
                  );
                },
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
