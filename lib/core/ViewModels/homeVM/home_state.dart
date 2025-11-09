import '../../models/category_model.dart';

class HomeState {
  final List<CategoryModel> categories;
  final bool isLoading;
  final String? error;

  const HomeState({
    required this.categories,
    this.isLoading = false,
    this.error,
  });

  HomeState copyWith({
    List<CategoryModel>? categories,
    bool? isLoading,
    String? error,
  }) {
    return HomeState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}