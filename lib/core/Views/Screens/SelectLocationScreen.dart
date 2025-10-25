import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import '../../ViewModels/Location/LocationCubit.dart';
import '../../ViewModels/Location/LocationState.dart';
import '../Themes/app_colors.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  late MapController mapController;

  @override
  void initState() {
    super.initState();
    // تهيئة MapController لبدء الخريطة من موقع المستخدم مباشرة
    mapController = MapController(
      initMapWithUserPosition: UserTrackingOption(enableTracking: true),

    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocationCubit(mapController)..fetchCurrentLocation(),
      child: Scaffold(
        appBar: AppBar(actionsPadding: EdgeInsetsGeometry.symmetric(vertical: 10,horizontal: 24),
          backgroundColor: AppColors.primary,
            actions:[ const Text("تحديد موقع العمل",style: TextStyle(fontSize: 20,color: AppColors.background),)
            ]),
        body: BlocBuilder<LocationCubit, LocationState>(
          builder: (context, state) {
            return Stack(
              children: [
                OSMFlutter(
                  controller: mapController,
                  osmOption: OSMOption(
                    zoomOption: ZoomOption(
                      minZoomLevel: 17.0,
                      maxZoomLevel: 18.0,
                      stepZoom: 2.0,
                    ),
                    userTrackingOption: UserTrackingOption(enableTracking: true),
                    userLocationMarker: UserLocationMaker(
                      personMarker: const MarkerIcon(
                        icon: Icon(Icons.my_location, color: Colors.blue, size: 50),
                      ),
                      directionArrowMarker: const MarkerIcon(
                        icon: Icon(Icons.navigation, color: Colors.blue, size: 50),
                      ),
                    ),
                  ),
                  onGeoPointClicked: (geoPoint) {
                    print("مختار: ${geoPoint.latitude}, ${geoPoint.longitude}");
                  },
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.my_location),
                        label: const Text("موقعي الحالي"),
                        onPressed: () => context.read<LocationCubit>().fetchCurrentLocation(),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.check),
                        label: const Text("تأكيد الموقع"),
                        onPressed: () {
                          final selectedLocation =
                              context.read<LocationCubit>().state.selectedLocation;
                          if (selectedLocation == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("رجاءً اختار موقعك على الخريطة"),
                              ),
                            );
                            return;
                          }
                          Navigator.pop(context, selectedLocation);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}