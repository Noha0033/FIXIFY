import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Repository/service_repository.dart';
import 'service_state.dart';

class ServiceCubit extends Cubit<ServiceState> {
  final ServiceRepository repository;

  ServiceCubit(this.repository) : super(ServiceInitial());

  void fetchServices() {
    emit(ServiceLoading());
    try {
      final services = repository.getAllServices();
      emit(ServiceLoaded(services));
    } catch (e) {
      emit(ServiceError('حدث خطأ أثناء تحميل الخدمات'));
    }
  }
}
