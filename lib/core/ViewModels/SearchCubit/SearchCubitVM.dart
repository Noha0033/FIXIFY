import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Models/SearchModel.dart';
import '../../models/category_model.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  Future<void> search(String query) async {
    if (query.length < 2) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    try {
      // محاكاة تأخير الشبكة
      await Future.delayed(const Duration(milliseconds: 500));

      // بيانات وهمية للبحث - يمكن استبدالها بـ API حقيقي
      final allResults = [
        SearchResult(
          id: '1',
          name: 'محمد أحمد - إصلاح منازل',
          rating: 4.8,
          reviewsCount: 127,
          location: 'الرياض، حي الملز',
          price: '120',
          imageUrl: null,
          type: 'artisan',
        ),
        SearchResult(
          id: '2',
          name: 'علي حسن - عامل صيانة',
          rating: 4.6,
          reviewsCount: 89,
          location: 'الرياض، حي العليا',
          price: '150',
          imageUrl: null,
          type: 'artisan',
        ),
        SearchResult(
          id: '3',
          name: 'فهد سعد - خدمات تنظيف',
          rating: 4.9,
          reviewsCount: 203,
          location: 'الرياض، حي النخيل',
          price: '200',
          imageUrl: null,
          type: 'artisan',
        ),
      ];

      final filteredResults = allResults
          .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

      emit(SearchLoaded(filteredResults));
    } catch (error) {
      emit(SearchError('فشل في البحث: $error'));
    }
  }

  void clearSearch() {
    emit(SearchInitial());
  }
}

// حالات البحث
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<SearchResult> results;

  SearchLoaded(this.results);
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}

// نموذج نتيجة البحث
