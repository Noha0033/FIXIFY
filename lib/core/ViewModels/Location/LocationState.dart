import 'package:equatable/equatable.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class LocationState extends Equatable {
  final GeoPoint? selectedLocation;
  final String? errorMessage;

  const LocationState({this.selectedLocation, this.errorMessage});

  factory LocationState.initial() => const LocationState();

  LocationState copyWith({GeoPoint? selectedLocation, String? errorMessage}) {
    return LocationState(
      selectedLocation: selectedLocation ?? this.selectedLocation,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [selectedLocation, errorMessage];
}
