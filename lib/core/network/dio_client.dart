// import 'package:al_fly/core/errors/failures.dart';
// import 'package:al_fly/core/network/dio_interceptor.dart';
// import 'package:al_fly/core/network/isolate_parser.dart';
// import 'package:al_fly/core/utils/services/firebase/firebase_crashlogger.dart';
// import 'package:al_fly/core/utils/services/main_box.dart';
// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';

// typedef ResponseConverter<T> = T Function(dynamic response);

// class DioClient with MainBoxMixin, FirebaseCrashLogger {
//   String baseUrl = const String.fromEnvironment("BASE_URL");

//   String? _auth;
//   bool _isUnitTest = false;
//   late Dio _dio;

//   DioClient({bool isUnitTest = false}) {
//     _isUnitTest = isUnitTest;

//     try {
//       _auth = getData(MainBoxKeys.token);
//     } catch (_) {}

//     _dio = _createDio();

//     if (!_isUnitTest) _dio.interceptors.add(DioInterceptor());
//   }

//   Dio get dio {
//     if (_isUnitTest) {
//       /// Return static dio if is unit test
//       return _dio;
//     } else {
//       /// We need to recreate dio to avoid token issue after login
//       try {
//         _auth = getData(MainBoxKeys.token);
//       } catch (_) {}

//       final dio = _createDio();

//       if (!_isUnitTest) dio.interceptors.add(DioInterceptor());

//       return dio;
//     }
//   }

//   Dio _createDio() => Dio(
//         BaseOptions(
//           baseUrl: baseUrl,
//           headers: {
//             'Content-Type': 'application/json',
//             'Accept': 'application/json',
//             if (_auth != null) ...{
//               'Authorization': _auth,
//             },
//           },
//           receiveTimeout: const Duration(minutes: 1),
//           connectTimeout: const Duration(minutes: 1),
//           validateStatus: (int? status) {
//             return status! > 0;
//           },
//         ),
//       );

//   Future<Either<Failure, T>> getRequest<T>(
//     String url, {
//     Map<String, dynamic>? queryParameters,
//     required ResponseConverter<T> converter,
//     bool isIsolate = true,
//   }) async {
//     try {
//       final response = await dio.get(url, queryParameters: queryParameters);
//       if ((response.statusCode ?? 0) < 200 ||
//           (response.statusCode ?? 0) > 201) {
//         throw DioException(
//           requestOptions: response.requestOptions,
//           response: response,
//         );
//       }

//       if (!isIsolate) {
//         return Right(converter(response.data));
//       }
//       final isolateParse = IsolateParser<T>(
//         response.data as Map<String, dynamic>,
//         converter,
//       );
//       final result = await isolateParse.parseInBackground();
//       return Right(result);
//     } on DioException catch (e, stackTrace) {
//       if (!_isUnitTest) {
//         nonFatalError(error: e, stackTrace: stackTrace);
//       }
//       return Left(
//         ServerFailure(
//             message: e.response?.data['error'] as String ?? "",
//             statusCode: e.response?.statusCode ?? 0),
//       );
//     }
//   }

//   Future<Either<Failure, T>> postRequest<T>(
//     String url, {
//     Map<String, dynamic>? data,
//     required ResponseConverter<T> converter,
//     bool isIsolate = true,
//   }) async {
//     try {
//       final response = await dio.post(url, data: data);

//       if ((response.statusCode ?? 0) < 200 ||
//           (response.statusCode ?? 0) > 201) {
//         throw DioException(
//           requestOptions: response.requestOptions,
//           response: response,
//         );
//       }

//       if (!isIsolate) {
//         return Right(converter(response.data));
//       }
//       final isolateParse = IsolateParser<T>(
//         response.data as Map<String, dynamic>,
//         converter,
//       );
//       final result = await isolateParse.parseInBackground();
//       return Right(result);
//     } on DioException catch (e, stackTrace) {
//       if (!_isUnitTest) {
//         nonFatalError(error: e, stackTrace: stackTrace);
//       }
//       return Left(
//         //   Failure(
//         // message:    e.response?.data['error'] as String ?? e.message,
//         //   ),

//         ServerFailure(
//             message: e.response?.data['error'] as String ?? e.message ?? "",
//             statusCode: e.response?.statusCode ?? 0),
//       );
//     }
//   }
// }
