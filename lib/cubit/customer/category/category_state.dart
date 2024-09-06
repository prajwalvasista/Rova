import 'package:al_rova/models/customer/product/get_all_category.dart';
import 'package:equatable/equatable.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitialState extends CategoryState {}

class CategoryLoadingState extends CategoryState {}

class CategoryErrorState extends CategoryState {
  final String message;

  const CategoryErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class GetAllCategorySuccessState extends CategoryState {
  final GetAllCategory getAllCategory;
  const GetAllCategorySuccessState(this.getAllCategory);

  @override
  List<Object> get props => [getAllCategory];
}
