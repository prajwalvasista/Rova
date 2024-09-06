import 'dart:convert';

import 'package:al_rova/core/errors/failures.dart';
import 'package:al_rova/core/network/api_endpoints.dart';
import 'package:al_rova/core/network/api_service.dart';
import 'package:al_rova/core/network/error_handler.dart';
import 'package:al_rova/core/network/network_info.dart';
import 'package:al_rova/models/auth/delete_account.dart';
import 'package:al_rova/models/auth/login_register_model.dart';
import 'package:al_rova/models/auth/register_model.dart';
import 'package:al_rova/models/auth/verify_otp_model.dart';
import 'package:al_rova/utils/services/local_storage.dart';
import 'package:dartz/dartz.dart';

class AuthRepository {
  final ApiService apiServcie;
  final NetworkInfo networkInfo;
  final MySharedPref mySharedPref;

  AuthRepository(
      {required this.apiServcie,
      required this.networkInfo,
      required this.mySharedPref});

// login repo
  Future<Either<Failure, LoginRegisterModel>> login(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiServcie.post(
            endPoint: APIEndPoints.login,
            data: jsonEncode(params),
            useToken: false);
        LoginRegisterModel loginRegisterModel =
            LoginRegisterModel.fromJson(response.data);
        return Right(loginRegisterModel);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

// register repo
  Future<Either<Failure, LoginRegisterModel>> register(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiServcie.post(
            endPoint: APIEndPoints.register,
            data: jsonEncode(params),
            useToken: false);
        LoginRegisterModel loginRegisterModel =
            LoginRegisterModel.fromJson(response.data);
        return Right(loginRegisterModel);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  Future<Either<Failure, VerifyOtpModel>> verifyOtp(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiServcie.post(
            endPoint: APIEndPoints.verifyOtpRegister,
            data: jsonEncode(params),
            useToken: false);
        VerifyOtpModel verifyOtpModel = VerifyOtpModel.fromJson(response.data);
        if (verifyOtpModel.response != null) {
          if (verifyOtpModel.response?.token != null) {
            mySharedPref.saveAccessToken(verifyOtpModel.response?.token ?? "");
            mySharedPref.saveUserData(jsonEncode(verifyOtpModel));
          }
          print("save access token ${mySharedPref.getAccessToken()}");
        }
        return Right(verifyOtpModel);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  Future<Either<Failure, DeleteAccountModel>> deleteUserAccount(
      String phoneNumber) async {
    if (await networkInfo.isConnected) {
      try {
        Map<String, dynamic> params = {
          "phoneNumber": phoneNumber,
        };
        final response = await apiServcie.post(
            endPoint: APIEndPoints.deleteAccount, data: jsonEncode(params));
        DeleteAccountModel deleteAccountModel =
            DeleteAccountModel.fromJson(response.data);

        return Right(deleteAccountModel);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
