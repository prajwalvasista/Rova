part of 'user_authentication_cubit.dart';

abstract class UserAuthState extends Equatable {
  const UserAuthState();
}

class UserAuthInitial extends UserAuthState {
  @override
  List<Object> get props => [];
}

class UserAuthLoadingState extends UserAuthState {
  const UserAuthLoadingState();

  @override
  List<Object?> get props => [];
}

class UserAuthErrorState extends UserAuthState {
  final String message;

  const UserAuthErrorState({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}

class UserAuthLoadedState extends UserAuthState {
  final bool isUserAuthenticated;

  const UserAuthLoadedState({
    required this.isUserAuthenticated,
  });

  @override
  List<Object?> get props => [
        isUserAuthenticated,
      ];
}

class UserAuthLoggedOutState extends UserAuthState {
  final String message;

  const UserAuthLoggedOutState({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
