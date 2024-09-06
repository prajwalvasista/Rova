import 'dart:convert';
import 'dart:io';

import 'package:al_rova/core/network/api_endpoints.dart';
import 'package:al_rova/utils/services/local_storage.dart';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;
  final MySharedPref _sharedPref;

  String? token;
  String? identifier;
  setHeaderWithOutToken() {
    Map<String, String> q = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    return q;
  }

  setHeaderWithToken() async {
    final tkn = _sharedPref.getAccessToken();

    if (tkn != "") {
      token = tkn;
    }

    Map<String, String> q = {
      HttpHeaders.contentTypeHeader: 'application/json',
      if (token != "") HttpHeaders.authorizationHeader: "Bearer $token",
    };
    return q;
  }

  ApiService(this._dio, this._sharedPref);
  
// get method
  Future<Response> get(
      {required String endPoint,
      dynamic data,
      dynamic params,
      bool useToken = true}) async {
    Map<String, String> headers;
    if (useToken) {
      headers = await setHeaderWithToken();
    } else {
      headers = setHeaderWithOutToken();
    }
    var response = await _dio.get('${APIEndPoints.baseUrl}$endPoint',
        data: data,
        queryParameters: params,
        options: Options(headers: headers));
    return response;
  }

// // for image upload in formdata
  Future<Response> imageUpload(
      {required String endPoint,
      required File file,
      bool useToken = true}) async {
    Map<String, String> headers;
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path, filename: fileName),
    });
    if (useToken) {
      headers = await setHeaderWithToken();
    } else {
      headers = setHeaderWithOutToken();
    }
    var response = await _dio.post('${APIEndPoints.baseUrlModel}$endPoint',
        data: formData, options: Options(headers: headers));
    print("response $response");
    return response;
  }
// post method
  Future<Response> post(
      {required String endPoint,
      dynamic data,
      dynamic params,
      bool useToken = true}) async {
    Map<String, String> headers;
    if (useToken) {
      headers = await setHeaderWithToken();
    } else {
      headers = setHeaderWithOutToken();
    }
    var response = await _dio.post('${APIEndPoints.baseUrl}$endPoint',
        data: data,
        queryParameters: params,
        options: Options(headers: headers));
    return response;
  }

// put method
  Future<Response> put(
      {required String endPoint, bool useToken = true, data}) async {
    Map<String, String> headers;
    if (useToken) {
      headers = await setHeaderWithToken();
    } else {
      headers = setHeaderWithOutToken();
    }
    var response = await _dio.put('${APIEndPoints.baseUrl}$endPoint',
        data: data, options: Options(headers: headers));
    return response;
  }

// patch method
  Future<Response> patch(
      {required String endPoint, bool useToken = true, data}) async {
    Map<String, String> headers;
    if (useToken) {
      headers = await setHeaderWithToken();
    } else {
      headers = setHeaderWithOutToken();
    }
    var response = await _dio.patch('${APIEndPoints.baseUrl}$endPoint',
        data: data, options: Options(headers: headers));
    return response;
  }

// delete method
  Future<Response> delete(
      {required String endPoint, bool useToken = true}) async {
    Map<String, String> headers;
    if (useToken) {
      headers = await setHeaderWithToken();
    } else {
      headers = setHeaderWithOutToken();
    }
    var response = await _dio.delete('${APIEndPoints.baseUrl}$endPoint',
        options: Options(headers: headers));
    return response;
  }
}
