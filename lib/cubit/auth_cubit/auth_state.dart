import 'package:al_rova/models/auth/delete_account.dart';
import 'package:al_rova/models/auth/login_register_model.dart';
import 'package:al_rova/models/auth/register_model.dart';
import 'package:al_rova/models/auth/verify_otp_model.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitialState extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthLoadingState extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthSuccessState extends AuthState {
  final VerifyOtpModel verifyOtpnModel;

  const AuthSuccessState(this.verifyOtpnModel);

  @override
  List<Object?> get props => [verifyOtpnModel];
}

class AuthErrorState extends AuthState {
  final String errorMessage;

  const AuthErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class AuthOtpSuccessState extends AuthState {
  final VerifyOtpModel verifyOtpnModel;

  const AuthOtpSuccessState(this.verifyOtpnModel);

  @override
  List<Object?> get props => [verifyOtpnModel];
}

// class AuthRegisterOtpSuccessState extends AuthState {
//   final VerifyOtpModel verifyOtpnModel;

//   const AuthRegisterOtpSuccessState(this.verifyOtpnModel);

//   @override
//   List<Object?> get props => [verifyOtpnModel];
// }

class LoginRegisterSuccessState extends AuthState {
  final LoginRegisterModel loginRegisterModel;

  const LoginRegisterSuccessState(this.loginRegisterModel);

  @override
  List<Object?> get props => [loginRegisterModel];
}

class AuthDeleteAccount extends AuthState {
  final DeleteAccountModel deleteAccountModel;

  const AuthDeleteAccount(this.deleteAccountModel);

  @override
  List<Object?> get props => [deleteAccountModel];
}
