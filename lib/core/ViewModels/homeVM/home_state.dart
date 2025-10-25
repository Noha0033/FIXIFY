import 'package:equatable/equatable.dart';
import '../../models/category_model.dart';

class HomeState extends Equatable {
  final List<CategoryModel> categories;

  const HomeState({required this.categories});

  @override
  List<Object?> get props => [categories];
}
