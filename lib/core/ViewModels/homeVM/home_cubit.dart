import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/category_model.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState(categories: []));

  Future<void> loadCategories() async {
    // إظهار حالة التحميل
    emit(state.copyWith(isLoading: true, error: null));

    try {
      // محاكاة تأخير الشبكة
      await Future.delayed(const Duration(milliseconds: 1000));

      final categories = [
        CategoryModel("إصلاح المنازل", "assets/icons/Vector (1).png"),
        CategoryModel("تنظيف", "assets/icons/Vector (2).png"),
        CategoryModel("عامل صيانة", "assets/icons/Vector (3).png"),
        CategoryModel("نقل الأثاث", "assets/icons/Vector (4).png"),
        CategoryModel("مزارع", "assets/icons/Vector (5).png"),
        CategoryModel("خدمات المركبات", "assets/icons/Vector (6).png"),
        CategoryModel("تصليح الأجهزة المنزلية", "assets/icons/Vector (7).png"),
        CategoryModel("التحكم بالآفات", "assets/icons/Vector (8).png"),
        CategoryModel("التركيب", "assets/icons/Vector (10).png"),
        CategoryModel("الدعم التقني", "assets/icons/Vector (11).png"),
        CategoryModel("خدمات الأمن", "assets/icons/Vector (12).png"),
      ];

      emit(state.copyWith(
        categories: categories,
        isLoading: false,
        error: null,
      ));
    } catch (error) {
      emit(state.copyWith(
        isLoading: false,
        error: 'فشل في تحميل الفئات: $error',
      ));
    }
  }
}