import 'package:al_rova/cubit/customer/category/category_state.dart';
import 'package:al_rova/repositories/customer/customer_product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CustomerProductRepository customerProductRepository;
  CategoryCubit({required this.customerProductRepository})
      : super(CategoryInitialState());

  //getAllCategory
  Future<dynamic> getAllCategory() async {
    emit(CategoryLoadingState());
    final res = await customerProductRepository.getAllCategory();
    res.fold((failure) {
      emit(CategoryErrorState(failure.message));
    }, (r) {
      return emit(GetAllCategorySuccessState(r));
    });
  }
}
