import 'package:al_rova/cubit/customer/edit_customer_cubit/edit_customer_state.dart';
import 'package:al_rova/repositories/customer/edit_customer_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditCustomerCubit extends Cubit<EditCustomerState> {
  final EditCustomerRepository editCustomerRepository;

  EditCustomerCubit({required this.editCustomerRepository})
      : super(EditCustomerInitial());

  Future<dynamic> editCustomer(
      String customerId, Map<String, dynamic> params) async {
    emit(EditCustomerLoading());
    final result =
        await editCustomerRepository.editCustomer(customerId, params);
    result.fold((failure) {
      emit(EditCustomerErrorState(failure.message));
    }, (r) {
      return emit(SuccessState(r));
    });
  }
}
