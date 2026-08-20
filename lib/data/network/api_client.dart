import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/domain/repositories/local_repository.dart';

abstract class IApiClient {
  Future<Response> getReq(
    String endpoint, {
    String? contentType,
    Map<String, String>? queryParams,
    dynamic Function(dynamic)? decoder,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
  });

  Future<Response> postReq(
    String endpoint,
    dynamic body, {
    String? contentType,
    dynamic Function(double)? uploadProgress,
    dynamic Function(dynamic)? decoder,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
  });

  Future<Response> patchReq(
    String endpoint,
    dynamic body, {
    String? contentType,
    dynamic Function(double)? uploadProgress,
    dynamic Function(dynamic)? decoder,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
  });

  Future<Response> deleteReq<T>(
    String endpoint, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
    T Function(dynamic)? decoder,
  });

  Future<Response> putReq<T>(
    String endpoint,
    dynamic body, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
    T Function(dynamic)? decoder,
    dynamic Function(double)? uploadProgress,
  });
  Future<File?> downloadFile(
    String url, {
    required String pathToSave,
  });
}

class ApiClient implements IApiClient {
  final GetConnect _connect;
  final Logger _logger;

  ApiClient({
    required GetConnect connect,
    required String baseURL,
    required Logger logger,
  })  : _baseURL = baseURL,
        _connect = connect,
        _logger = logger {
    connect.baseUrl = baseURL;
    connect.timeout = 20.seconds;

    final client = connect.httpClient;

    client.addRequestModifier((Request request) async {
      // Log the request using the custom logger
      _logger.d('Sending Request:');
      _logger.d('URL: ${request.url}');
      _logger.d('Method: ${request.method}');
      final token = await find<LocalRepository>().getAccessToken();
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      return request;
    });

    client.addResponseModifier((request, response) {
      _logger.d('Response Received:');
      _logger.d('URL: ${response.request?.url}');
      _logger.d('Status Code: ${response.statusCode}');
      _logger.d('Response Data: ${response.body}');
      return response;
    });
  }

  final String _baseURL;
  String get url => _baseURL;
  final http.Client client = http.Client();

  @override
  Future<Response> getReq(
    String endpoint, {
    String? contentType,
    Map<String, String>? queryParams,
    dynamic Function(dynamic)? decoder,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
  }) {
    return _connect.get(
      endpoint,
      contentType: contentType,
      decoder: decoder,
      headers: headers,
      query: query,
    );
  }

  @override
  Future<Response> postReq(
    String endpoint,
    dynamic body, {
    String? contentType,
    dynamic Function(double)? uploadProgress,
    dynamic Function(dynamic)? decoder,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
  }) {
    return _connect.post(
      endpoint,
      body,
      contentType: contentType,
      uploadProgress: uploadProgress,
      decoder: decoder,
      headers: headers,
      query: query,
    );
  }

  @override
  Future<Response> patchReq(
    String endpoint,
    dynamic body, {
    String? contentType,
    dynamic Function(double)? uploadProgress,
    dynamic Function(dynamic)? decoder,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
  }) {
    return _connect.patch(
      endpoint,
      body,
      contentType: contentType,
      uploadProgress: uploadProgress,
      decoder: decoder,
      headers: headers,
      query: query,
    );
  }

  @override
  Future<Response> deleteReq<T>(
    String endpoint, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
    T Function(dynamic)? decoder,
  }) {
    return _connect.delete(
      endpoint,
      contentType: contentType,
      decoder: decoder,
      headers: headers,
      query: query,
    );
  }

  @override
  Future<Response> putReq<T>(
    String endpoint,
    dynamic body, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
    T Function(dynamic)? decoder,
    dynamic Function(double)? uploadProgress,
  }) {
    return _connect.put(
      endpoint,
      body,
      contentType: contentType,
      decoder: decoder,
      headers: headers,
      query: query,
      uploadProgress: uploadProgress,
    );
  }

  @override
  Future<File?> downloadFile(
    String url, {
    required String pathToSave,
  }) async {
    final req = await client.get(
      Uri.parse(url),
    );
    final bytes = req.bodyBytes;
    File file = File(pathToSave);
    await file.writeAsBytes(bytes);

    return file;
    // final res = await getReq(url);
    // if (!res.isOk || res.statusCode != 200) {
    //   throw FileException(cause: res.statusText);
    // }
    // final streamBytes = res.bodyBytes;
    // final bytes = await streamBytes.toBytes();
    // File file = File('$pathToSave/$fileName');
    // await file.writeAsBytes(bytes);
    // return file;
  }
}

extension StreamListIntExtension on Stream<List<int>>? {
  Future<List<int>> toBytes() async {
    final List<int> result = [];
    await for (final chunk in this ?? const Stream.empty()) {
      result.addAll(chunk);
    }
    return result;
  }
}
