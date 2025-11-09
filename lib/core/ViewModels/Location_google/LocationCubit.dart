import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../Models/LocationModel.dart';
import '../../Repository/LocationService.dart';

abstract class LocationState {}

class LocationInitial extends LocationState {}
class LocationLoading extends LocationState {}
class LocationLoaded extends LocationState {
  final LocationModel location;
  LocationLoaded(this.location);
}
class LocationError extends LocationState {
  final String message;
  LocationError(this.message);
}

class LocationCubit extends Cubit<LocationState> {
  final LocationService _service;
  StreamSubscription<Position>? _sub;

  LocationCubit(this._service) : super(LocationInitial());

  Future<void> fetchCurrentLocation() async {
    try {
      emit(LocationLoading());
      final pos = await _service.getCurrentPosition();
      if (pos == null) {
        emit(LocationError('Location permission denied or not available'));
        return;
      }
      emit(LocationLoaded(LocationModel(latitude: pos.latitude, longitude: pos.longitude)));
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  void startListening() {
    _sub = _service.getPositionStream().listen((pos) {
      emit(LocationLoaded(LocationModel(latitude: pos.latitude, longitude: pos.longitude)));
    }, onError: (e) {
      emit(LocationError(e.toString()));
    });
  }

  // ✅ دالة جديدة لتحديث الموقع اليدوي (من الخريطة)
  void setLocation(LatLng newLocation) {
    emit(LocationLoaded(
      LocationModel(
        latitude: newLocation.latitude,
        longitude: newLocation.longitude,
      ),
    ));
  }

  void stopListening() {
    _sub?.cancel();
    _sub = null;
  }

  @override
  Future<void> close() {
    stopListening();
    return super.close();
  }
}
