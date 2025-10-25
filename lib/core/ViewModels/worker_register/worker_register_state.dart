part of 'worker_register_cubit.dart';

class WorkerRegisterState extends Equatable {
  final bool isLoading;
  final bool success;
  final String? error;
  final LatLng? location;

  const WorkerRegisterState({
    this.isLoading = false,
    this.success = false,
    this.error,
    this.location,
  });

  WorkerRegisterState copyWith({
    bool? isLoading,
    bool? success,
    String? error,
    LatLng? location,
  }) {
    return WorkerRegisterState(
      isLoading: isLoading ?? this.isLoading,
      success: success ?? this.success,
      error: error,
      location: location ?? this.location,
    );
  }

  @override
  List<Object?> get props => [isLoading, success, error, location];
}
