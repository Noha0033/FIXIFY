import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:latlong2/latlong.dart';
import 'package:equatable/equatable.dart';

part 'worker_register_state.dart';

class WorkerRegisterCubit extends Cubit<WorkerRegisterState> {
  WorkerRegisterCubit() : super(const WorkerRegisterState());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  LatLng? selectedLocation;

  void setLocation(LatLng location) {
    selectedLocation = location;
    emit(state.copyWith(location: location));
  }

  Future<void> submitWorker({
    required String name,
    required String phone,
    required String profession,
    required String experience,
    required String bio,
    required String governorate,
    required String district,
    required List<File> gallery,
  }) async {
    if (selectedLocation == null) {
      emit(state.copyWith(error: "الرجاء اختيار الموقع على الخريطة"));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

    try {
      List<String> galleryUrls = [];
      for (var img in gallery) {
        final ref = _storage
            .ref("workers_gallery/${DateTime.now().millisecondsSinceEpoch}.jpg");
        await ref.putFile(img);
        galleryUrls.add(await ref.getDownloadURL());
      }

      await _firestore.collection('workers').add({
        "name": name,
        "phone": phone,
        "profession": profession,
        "experience": experience,
        "bio": bio,
        "governorate": governorate,
        "district": district,
        "latitude": selectedLocation!.latitude,
        "longitude": selectedLocation!.longitude,
        "gallery": galleryUrls,
        "createdAt": FieldValue.serverTimestamp(),
      });

      emit(state.copyWith(isLoading: false, success: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
