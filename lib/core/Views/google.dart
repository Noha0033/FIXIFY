import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../ViewModels/worker_register/LocationViewModel.dart';
import '../ViewModels/Location_google/LocationCubit.dart';
import 'Themes/app_colors.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  late final MapViewModel viewModel;

  LatLng? selectedLocation; // الموقع الذي يختاره المستخدم
  bool _locationChosen = false; // ✅ حالة جديدة لتتبع إذا المستخدم فعلاً اختار موقع

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<LocationCubit>();
      viewModel = MapViewModel(cubit: cubit);
      viewModel.init();
    });
  }

  @override
  void dispose() {
    viewModel.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _moveCameraTo(double lat, double lng) {
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 16));
  }

  // ✅ عند النقر على الخريطة
  void _onMapTapped(LatLng position) {
    setState(() {
      selectedLocation = position;
      _locationChosen = true; // تم اختيار موقع
      _markers
        ..clear()
        ..add(
          Marker(
            markerId: const MarkerId('selected'),
            position: position,
            infoWindow: const InfoWindow(title: 'الموقع المختار'),
          ),
        );
    });
  }

  // ✅ تحديد موقع المستخدم الحالي يدوياً
  void _setCurrentLocation(LocationCubit cubit) async {
    await cubit.fetchCurrentLocation();
    final state = cubit.state;
    if (state is LocationLoaded) {
      final lat = state.location.latitude;
      final lng = state.location.longitude;

      setState(() {
        selectedLocation = LatLng(lat, lng);
        _locationChosen = true; // ✅ تم اختيار الموقع فعلاً
        _markers
          ..clear()
          ..add(Marker(
            markerId: const MarkerId('current'),
            position: LatLng(lat, lng),
            infoWindow: const InfoWindow(title: 'موقعي الحالي'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          ));
      });

      _moveCameraTo(lat, lng);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LocationCubit>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          "تحديد موقع العمل",
          style: TextStyle(fontSize: 20, color: AppColors.background),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, state) {
          Widget child;

          child = GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(15.3694, 44.1910),
              zoom: 13,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onTap: _onMapTapped,
          );

          return Stack(
            children: [
              Positioned.fill(child: child),

              // ✅ زر تأكيد الموقع يظهر فقط بعد اختيار موقع فعلاً
              if (_locationChosen)
                Positioned(
                  bottom: 80,
                  left: 80,
                  right: 80,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, selectedLocation);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "تأكيد الموقع",
                      style: TextStyle(fontSize: 16, color: AppColors.background),
                    ),
                  ),
                ),

              // ✅ زر لتحديد موقع المستخدم الحالي (أسفل منتصف الشاشة)
              Positioned(
                bottom: 20,
                left: 80,
                right: 80,
                child: ElevatedButton.icon(
                  onPressed: () => _setCurrentLocation(cubit),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.my_location, color: AppColors.background),
                  label: const Text(
                    "تحديد موقعي الحالي",
                    style: TextStyle(fontSize: 16, color: AppColors.background),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
