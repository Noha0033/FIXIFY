import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Models/CraftsmanModel.dart';
import '../../Repository/CraftsmanRepository.dart';

abstract class NearbyCraftsmanState {}

class NearbyInitial extends NearbyCraftsmanState {}
class NearbyLoading extends NearbyCraftsmanState {}
class NearbyLoaded extends NearbyCraftsmanState {
  final List<CraftsmanModel> artisans;
  NearbyLoaded(this.artisans);
}
class NearbyError extends NearbyCraftsmanState {
  final String message;
  NearbyError(this.message);
}

class NearbyCraftsmanCubit extends Cubit<NearbyCraftsmanState> {
  final CraftsmanRepository repo;
  NearbyCraftsmanCubit(this.repo) : super(NearbyInitial());

  Future<void> loadNearby(double lat, double lng) async {
    emit(NearbyLoading());
    try {
      final data = await repo.fetchNearbyCrafstman(lat, lng);
      emit(NearbyLoaded(data));
    } catch (e) {
      emit(NearbyError(e.toString()));
    }
  }
}
