import 'Location_google/LocationCubit.dart';

class MapViewModel {
  final LocationCubit cubit;
  MapViewModel({required this.cubit});


  Future<void> init() async {
    await cubit.fetchCurrentLocation();
    cubit.startListening();
  }


  void dispose() {
    cubit.stopListening();
  }
}