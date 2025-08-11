import 'dart:convert';

import 'package:ecommerce/core/network/http.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'http_test.mocks.dart';

@GenerateMocks([http.Client, http.MultipartRequest])
void main() {
  late MockClient mockClient;
  late HttpClient httpClient;
  late MockMultipartRequest mockMultipartRequest;

  setUp(() {
    mockClient = MockClient();
    mockMultipartRequest = MockMultipartRequest();
    httpClient = HttpClient(
        multipartRequestFactory: (method, url) => mockMultipartRequest,
        client: mockClient);
  });

  const tUrl = 'http://localhost:3000/products';
  const tBody = {'name': 'HP Victus 15', 'price': '123.45'};
  const tResponse = HttpResponse(body: '', statusCode: 200);

  group('get', () {
    test('should return response of client.get wrapped in HttpResponse',
        () async {
      when(mockClient.get(Uri.parse(tUrl), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('', 200));

      final result = await httpClient.get(tUrl);

      expect(result, tResponse);
    });
  });

  group('post', () {
    test(
        'should call client.post with headers and return the response as HttpResponse',
        () async {
      when(mockClient.post(Uri.parse(tUrl),
              body: jsonEncode(tBody), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('', 200));

      final result = await httpClient.post(tUrl, tBody);

      expect(result, tResponse);
    });
  });

  group('put', () {
    test(
        'should call client.put with headers and return the response as HttpResponse',
        () async {
      when(mockClient.put(Uri.parse(tUrl),
              body: jsonEncode(tBody), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('', 200));

      final result = await httpClient.put(tUrl, tBody);

      expect(result, tResponse);
    });
  });

  group('delete', () {
    test(
        'should return HttpResponse when the call to client.delete is successful',
        () async {
      when(mockClient.delete(Uri.parse(tUrl), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('', 200));

      final result = await httpClient.delete(tUrl);

      expect(result, tResponse);
    });
  });

  group('uploadFile', () {
    test(
        'should return HttpResponse when the call to client.send is successful',
        () async {
      when(mockMultipartRequest.send()).thenAnswer((_) async =>
          http.StreamedResponse(Stream.fromIterable([utf8.encode('')]), 200));

      when(mockMultipartRequest.fields).thenReturn({});
      when(mockMultipartRequest.files).thenReturn([]);
      when(mockMultipartRequest.headers).thenReturn({});

      final result = await httpClient.uploadFile(tUrl, HttpMethod.post, tBody, [
        const UploadFile(key: 'image', path: 'test/core/network/http_test.dart')
      ]);

      expect(result, tResponse);
    });
  });
}