import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../constants/constants.dart';

// Abstract class to check network connectivity status
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;
  
  // Development flag - set to true to bypass network checks
  static const bool _bypassNetworkCheck = false;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected async {
    // Development bypass
    if (_bypassNetworkCheck) {
      print('🚧 DEVELOPMENT MODE: Bypassing network check');
      return true;
    }
    
    print('🔍 Checking network connectivity...');
    try {
      final connected = await connectionChecker.hasConnection
          .timeout(
            connectionTimeout,
            onTimeout: () {
              print('⏰ Network connectivity check timed out');
              return false;
            },
          )
          .then((connected) {
            print('🌐 Network connectivity result: ${connected ? "Connected" : "Disconnected"}');
            return connected;
          });
      
      // Additional network test - try to make a simple HTTP request
      if (connected) {
        print('🔍 Testing actual network connectivity with a simple request...');
        try {
          final addresses = await connectionChecker.addresses;
          print('✅ Network addresses available: ${addresses.length}');
        } catch (e) {
          print('⚠️ Network test warning: $e');
        }
      }
      
      return connected;
    } catch (e) {
      print('❌ Error checking network connectivity: $e');
      return false;
    }
  }
}
