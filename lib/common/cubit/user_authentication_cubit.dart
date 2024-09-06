import 'dart:async';
import 'dart:developer';

import 'package:al_rova/utils/services/local_storage.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_authentication_state.dart';

class UserAuthCubit extends Cubit<UserAuthState> {
  final MySharedPref localDataSource;

  UserAuthCubit({required this.localDataSource}) : super(UserAuthInitial());

  bool _isUserLoggedIn = false;

  void logoutUser() {
    _isUserLoggedIn = false;
  }

  bool isUserLoggedIn() => _isUserLoggedIn;

  FutureOr<void> checkUserAuthentication() async {
    emit(const UserAuthLoadingState());
    final String token = localDataSource.getAccessToken();

    if (token.trim().isNotEmpty) {
      _isUserLoggedIn = true;
      emit(
        const UserAuthLoadedState(isUserAuthenticated: true),
      );
    } else {
      log('Unauthenticated user', name: 'Auth cubit');

      _isUserLoggedIn = false;

      emit(
        const UserAuthLoadedState(isUserAuthenticated: false),
      );
    }
  }

  FutureOr<bool> isAuthenticatedUser() async {
    final String token = localDataSource.getAccessToken();

    if (token.trim().isNotEmpty) {
      _isUserLoggedIn = true;
      return true;
    } else {
      return false;
    }
  }

  logout() async {
    try {
      localDataSource.logout();
      emit(const UserAuthLoggedOutState(message: "Sucessfully logged out"));
    } catch (e) {
      debugger(message: e.toString());
      emit(UserAuthErrorState(message: e.toString()));
    }
  }
}
