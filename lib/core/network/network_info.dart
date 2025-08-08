
// Abstract class to check network connectivity status
abstract class NetworkInfo {
  Future<bool> get isConnected;
}