import 'package:al_rova/core/errors/failures.dart';
import 'package:al_rova/di.dart';
import 'package:al_rova/utils/services/local_storage.dart';
import 'package:al_rova/utils/services/navigation_service.dart';
import 'package:al_rova/views/auth/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      // dio error so its an error from response of the API or from dio itself
      failure = _handleError(error);
    } else {
      // default error
      failure = DataSource.DEFAULT.getFailure();
    }
  }
}

Failure _handleError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return DataSource.CONNECT_TIMEOUT.getFailure();
    case DioExceptionType.sendTimeout:
      return DataSource.SEND_TIMEOUT.getFailure();
    case DioExceptionType.receiveTimeout:
      return DataSource.RECIEVE_TIMEOUT.getFailure();
    case DioExceptionType.badResponse:
      if (error.response != null &&
          error.response?.statusCode != null &&
          error.response?.statusMessage != null) {
        if (error.response!.statusCode == 401) {
          final localStorage = getIt<MySharedPref>();
          navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Login()),
              (route) => false);
          localStorage.logout();
          return ServerFailure(
              statusCode: error.response?.statusCode ?? 0,
              message:
                  '${error.response?.statusMessage}: Token is expired' ?? "");
        } else if (error.response!.statusCode == 500) {
          return ServerFailure(
              statusCode: 500, message: "Internal Server Error");
        } else if (error.response!.statusCode == 400) {
          return ServerFailure(
              statusCode: error.response?.statusCode ?? 0,
              message: error.response?.data["resultMessage"] ??
                  error.response?.data["errorMessage"] ??
                  error.response?.data["message"]);
        } else {
          print('error-response');
          return ServerFailure(
              statusCode: error.response?.statusCode ?? 0,
              message: error.response?.data["resultMessage"] ??
                  error.response?.data["errorMessage"] ??
                  error.response?.data["message"]);
        }
        //  error.response?.statusMessage ?? "");
      } else {
        return DataSource.DEFAULT.getFailure();
      }

    case DioExceptionType.cancel:
      return DataSource.CANCEL.getFailure();
    default:
      return DataSource.DEFAULT.getFailure();
  }
}

enum DataSource {
  // ignore: constant_identifier_names
  SUCCESS,
  // ignore: constant_identifier_names
  NO_CONTENT,
  // ignore: constant_identifier_names
  BAD_REQUEST,
  // ignore: constant_identifier_names
  FORBIDDEN,
  // ignore: constant_identifier_names
  UNAUTORISED,
  // ignore: constant_identifier_names
  NOT_FOUND,
  // ignore: constant_identifier_names
  INTERNAL_SERVER_ERROR,
  // ignore: constant_identifier_names
  CONNECT_TIMEOUT,
  // ignore: constant_identifier_names
  CANCEL,
  // ignore: constant_identifier_names
  RECIEVE_TIMEOUT,
  // ignore: constant_identifier_names
  SEND_TIMEOUT,
  // ignore: constant_identifier_names
  CACHE_ERROR,
  // ignore: constant_identifier_names
  NO_INTERNET_CONNECTION,
  // ignore: constant_identifier_names
  DEFAULT
}

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    // var mContext = navigatorKey!.currentState!.context;
    switch (this) {
      case DataSource.SUCCESS:
        return ServerFailure(
            statusCode: ResponseCode.SUCCESS, message: ResponseMessage.SUCCESS);
      case DataSource.NO_CONTENT:
        return ServerFailure(
            statusCode: ResponseCode.NO_CONTENT,
            message: ResponseMessage.NO_CONTENT);
      case DataSource.BAD_REQUEST:
        return ServerFailure(
            statusCode: ResponseCode.BAD_REQUEST,
            message: ResponseMessage.BAD_REQUEST);
      case DataSource.FORBIDDEN:
        return ServerFailure(
            statusCode: ResponseCode.FORBIDDEN,
            message: ResponseMessage.FORBIDDEN);
      case DataSource.UNAUTORISED:
        return ServerFailure(
            statusCode: ResponseCode.UNAUTORISED,
            message: ResponseMessage.UNAUTORISED);
      case DataSource.NOT_FOUND:
        return ServerFailure(
            statusCode: ResponseCode.NOT_FOUND,
            message: ResponseMessage.NOT_FOUND);
      case DataSource.INTERNAL_SERVER_ERROR:
        return ServerFailure(
            statusCode: ResponseCode.INTERNAL_SERVER_ERROR,
            message: ResponseMessage.INTERNAL_SERVER_ERROR);
      case DataSource.CONNECT_TIMEOUT:
        return ServerFailure(
            statusCode: ResponseCode.CONNECT_TIMEOUT,
            message: ResponseMessage.CONNECT_TIMEOUT);
      case DataSource.CANCEL:
        return ServerFailure(
            statusCode: ResponseCode.CANCEL, message: ResponseMessage.CANCEL);
      case DataSource.RECIEVE_TIMEOUT:
        return ServerFailure(
            statusCode: ResponseCode.RECIEVE_TIMEOUT,
            message: ResponseMessage.RECIEVE_TIMEOUT);
      case DataSource.SEND_TIMEOUT:
        return ServerFailure(
            statusCode: ResponseCode.SEND_TIMEOUT,
            message: ResponseMessage.SEND_TIMEOUT);
      case DataSource.CACHE_ERROR:
        return ServerFailure(
            statusCode: ResponseCode.CACHE_ERROR,
            message: ResponseMessage.CACHE_ERROR);
      case DataSource.NO_INTERNET_CONNECTION:
        print("internet not working ");
        return ServerFailure(
            statusCode: ResponseCode.NO_INTERNET_CONNECTION,
            message: ResponseMessage.NO_INTERNET_CONNECTION);
      case DataSource.DEFAULT:
        return ServerFailure(
            statusCode: ResponseCode.DEFAULT, message: ResponseMessage.DEFAULT);
    }
  }
}

class ResponseCode {
  // ignore: constant_identifier_names
  static const int SUCCESS = 200; // success with data
  // ignore: constant_identifier_names
  static const int NO_CONTENT = 201; // success with no data (no content)
  // ignore: constant_identifier_names
  static const int BAD_REQUEST = 400; // failure, API rejected request
  // ignore: constant_identifier_names
  static const int UNAUTORISED = 401; // failure, user is not authorised
  // ignore: constant_identifier_names
  static const int FORBIDDEN = 403; //  failure, API rejected request
  // ignore: constant_identifier_names
  static const int INTERNAL_SERVER_ERROR = 500; // failure, crash in server side
  // ignore: constant_identifier_names
  static const int NOT_FOUND = 404; // failure, not found

  // local status code
  // ignore: constant_identifier_names
  static const int CONNECT_TIMEOUT = -1;
  // ignore: constant_identifier_names
  static const int CANCEL = -2;
  // ignore: constant_identifier_names
  static const int RECIEVE_TIMEOUT = -3;
  // ignore: constant_identifier_names
  static const int SEND_TIMEOUT = -4;
  // ignore: constant_identifier_names
  static const int CACHE_ERROR = -5;
  // ignore: constant_identifier_names
  static const int NO_INTERNET_CONNECTION = -6;
  // ignore: constant_identifier_names
  static const int DEFAULT = -7;
}

class ResponseMessage {
  // ignore: constant_identifier_names
  static const String SUCCESS = "Sucess"; // success with data
  // ignore: constant_identifier_names
  static const String NO_CONTENT =
      "Success"; // success with no data (no content)
  // ignore: constant_identifier_names
  static const String BAD_REQUEST =
      "BadRequestError"; // failure, API rejected request
  // ignore: constant_identifier_names
  static const String UNAUTORISED =
      "UnauthorizedError"; // failure, user is not authorised
  // ignore: constant_identifier_names
  static const String FORBIDDEN =
      "ForbiddenError"; //  failure, API rejected request
  // ignore: constant_identifier_names
  static const String INTERNAL_SERVER_ERROR =
      "InternalServerError"; // failure, crash in server side
  // ignore: constant_identifier_names
  static const String NOT_FOUND =
      "NotFoundError"; // failure, crash in server side

  // local status code
  // ignore: constant_identifier_names
  static const String CONNECT_TIMEOUT = "TimeoutError";
  // ignore: constant_identifier_names
  static const String CANCEL = "DefaultError";
  // ignore: constant_identifier_names
  static const String RECIEVE_TIMEOUT = "TimeoutError";
  // ignore: constant_identifier_names
  static const String SEND_TIMEOUT = "TimeoutError";
  // ignore: constant_identifier_names
  static const String CACHE_ERROR = "CacheError";
  // ignore: constant_identifier_names
  static const String NO_INTERNET_CONNECTION = "Internet is not working.";
  // ignore: constant_identifier_names
  static const String DEFAULT = "Something went wrong.";
}

class ApiInternalStatus {
  // ignore: constant_identifier_names
  static const int SUCCESS = 200;
  // ignore: constant_identifier_names
  static const int FAILURE = 400;
}
