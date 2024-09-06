import 'package:al_rova/cubit/auth_cubit/auth_state.dart';
import 'package:al_rova/repositories/auth/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  AuthCubit({required this.authRepository}) : super(AuthInitialState());

// login cubit
  userLogin(Map<String, dynamic> params) async {
    emit(AuthLoadingState());
    try {
      var result = await authRepository.login(params);

      result.fold(
        (failure) {
          emit(AuthErrorState(failure.errorMessage));
        },
        ((response) {
          return emit(LoginRegisterSuccessState(response));
        }),
      );
    } catch (err) {
      emit(AuthErrorState(err.toString()));
    }
  }
// user Register cubit
  userRegister(Map<String, dynamic> params) async {
    emit(AuthLoadingState());
    try {
      var result = await authRepository.register(params);

      result.fold(
        (failure) {
          emit(AuthErrorState(failure.errorMessage));
        },
        ((response) {
          print(' this is loggin respo $response');

          return emit(LoginRegisterSuccessState(response));
        }),
      );
    } catch (err) {
      emit(AuthErrorState(err.toString()));
    }
  }

  // verifyOtpLogin(String phoneNumber, String otp) async {
  //   emit(AuthLoadingState());
  //   try {
  //     var result = await authRepository.verifyOtpLogin(phoneNumber, otp);

  //     result.fold(
  //       (failure) {
  //         emit(AuthErrorState(failure.errorMessage));
  //       },
  //       ((response) {
  //         print(' this is loggin respo $response');

  //         return emit(AuthLoginOtpSuccessState(response));
  //       }),
  //     );
  //   } catch (err) {
  //     emit(AuthErrorState(err.toString()));
  //   }
  // }

  verifyOtp(Map<String, dynamic> params) async {
    emit(AuthLoadingState());
    try {
      var result = await authRepository.verifyOtp(params);
      result.fold(
        (failure) {
          emit(AuthErrorState(failure.errorMessage));
        },
        ((response) {
          print(' this is  respo $response');

          return emit(AuthOtpSuccessState(response));
        }),
      );
    } catch (err) {
      emit(AuthErrorState(err.toString()));
    }
  }

  deleteUserAccount(String phoneNumber) async {
    emit(AuthLoadingState());
    try {
      var result = await authRepository.deleteUserAccount(phoneNumber);

      result.fold(
        (failure) {
          emit(AuthErrorState(failure.errorMessage));
        },
        ((response) {
          print(' this is  respo $response');

          return emit(AuthDeleteAccount(response));
        }),
      );
    } catch (err) {
      emit(AuthErrorState(err.toString()));
    }
  }
}
