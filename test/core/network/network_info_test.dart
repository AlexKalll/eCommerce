import 'package:ecommerce/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([InternetConnectionChecker])
void main() {
  late MockInternetConnectionChecker mockInternetConnectionChecker;
  late NetworkInfoImpl networkInfoImpl;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
  });

  test(
      'should return true when the call to InternetConnectionChecker.hasConnection is successful',
      () async {
    networkInfoImpl = NetworkInfoImpl(mockInternetConnectionChecker);
    when(mockInternetConnectionChecker.hasConnection)
        .thenAnswer((_) async => true);

    final result = await networkInfoImpl.isConnected;

    expect(result, true);
    verify(mockInternetConnectionChecker.hasConnection);
    verifyNoMoreInteractions(mockInternetConnectionChecker);
  });

  test(
      'should return false when the call to InternetConnectionChecker.hasConnection is unsuccessful',
      () async {
    networkInfoImpl = NetworkInfoImpl(mockInternetConnectionChecker);
    when(mockInternetConnectionChecker.hasConnection)
        .thenAnswer((_) async => false);

    final result = await networkInfoImpl.isConnected;

    expect(result, false);
    verify(mockInternetConnectionChecker.hasConnection);
    verifyNoMoreInteractions(mockInternetConnectionChecker);
  });
}