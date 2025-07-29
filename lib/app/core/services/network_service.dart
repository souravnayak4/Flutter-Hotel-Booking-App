import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkServiceHelper {
  static Future<bool> hasInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    return connectivityResult != ConnectivityResult.none;
  }
}
