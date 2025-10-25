import 'package:bloc/bloc.dart';
import 'package:flutter_osm_interface/src/types/geo_point.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart' hide GeoPoint;
import 'package:equatable/equatable.dart';


import 'LocationState.dart';

class LocationCubit extends Cubit<LocationState> {
  final MapController mapController;

  LocationCubit(this.mapController) : super(LocationState.initial());

  Future<void> fetchCurrentLocation() async {
    try {
      final GeoPoint? currentLocation = await mapController.myLocation();
      if (currentLocation != null) {
        emit(state.copyWith(
          selectedLocation: GeoPoint(
            latitude: currentLocation.latitude,
            longitude: currentLocation.longitude,
          ),
        ));
        mapController.goToLocation(currentLocation);
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: "خطأ في تحديد الموقع: $e"));
    }
  }

  void selectLocation(GeoPoint point) {
    emit(state.copyWith(selectedLocation: point));
    mapController.addMarker(point);
  }
}
