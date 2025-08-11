import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../constants/constants.dart';

enum HttpMethod { post, put }

class UploadFile extends Equatable {
  final String key;
  final String path;

  const UploadFile({
    required this.key,
    required this.path,
  });

  @override
  List<Object> get props => [key, path];
}

http.MultipartRequest multipartRequestFactory(HttpMethod method, String url) {
  return http.MultipartRequest(method.name.toUpperCase(), Uri.parse(url));
}

class HttpResponse extends Equatable {
  final String reasonPhrase;
  final int statusCode;
  final String body;

  const HttpResponse(
      {this.reasonPhrase = '', required this.statusCode, required this.body});

  @override
  List<Object> get props => [reasonPhrase, statusCode, body];
}

class HttpClient {
  final http.Client client;
  final http.MultipartRequest Function(HttpMethod, String)
      multipartRequestFactory;

  io.Socket? _socket;

  final _defaultHeaders = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  HttpClient({
    required this.multipartRequestFactory,
    required this.client,
  });

  set authToken(String token) {
    _defaultHeaders['Authorization'] = 'Bearer $token';
    _socket = io.io(socketUrl, <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
      'extraHeaders': <String, String>{
        'authorization': 'Bearer $token',
      },
    });
  }

  io.Socket get socket => _socket!;

  Future<HttpResponse> get(String url) async {
    final response = await client.get(Uri.parse(url), headers: _defaultHeaders);

    return HttpResponse(
      statusCode: response.statusCode,
      body: response.body,
    );
  }

  Future<HttpResponse> post(String url, Map<String, dynamic> body) async {
    final response = await client.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: _defaultHeaders,
    );

    return HttpResponse(
      statusCode: response.statusCode,
      body: response.body,
    );
  }

  Future<HttpResponse> put(String url, Map<String, dynamic> body) async {
    final response = await client.put(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: _defaultHeaders,
    );

    return HttpResponse(
      statusCode: response.statusCode,
      body: response.body,
    );
  }

  Future<HttpResponse> delete(String url) async {
    final response =
        await client.delete(Uri.parse(url), headers: _defaultHeaders);

    return HttpResponse(
      statusCode: response.statusCode,
      body: response.body,
    );
  }

  Future<HttpResponse> uploadFile(
    String url,
    HttpMethod method,
    Map<String, String> body,
    List<UploadFile> files,
  ) async {
    var request = multipartRequestFactory(method, url);

    request.headers.addEntries(_defaultHeaders.entries);

    request.fields.addAll(body);

    for (var file in files) {
      request.files.add(await http.MultipartFile.fromPath(
        file.key,
        file.path,
        contentType: _inferMediaType(file.path),
      ));
    }

    http.StreamedResponse streamedResponse = await request.send();

    final response = await streamedResponse.stream.bytesToString();
    return HttpResponse(
      statusCode: streamedResponse.statusCode,
      body: response,
      reasonPhrase: streamedResponse.reasonPhrase ?? '',
    );
  }

  MediaType _inferMediaType(String path) {
    if (path.endsWith('.jpg') || path.endsWith('.jpeg')) {
      return MediaType('image', 'jpeg');
    } else if (path.endsWith('.png')) {
      return MediaType('image', 'png');
    } else if (path.endsWith('.gif')) {
      return MediaType('image', 'gif');
    } else {
      return MediaType('image', 'jpeg');
    }
  }
}