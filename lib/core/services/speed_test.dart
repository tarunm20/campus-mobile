import 'package:campus_mobile_experimental/core/models/speed_test.dart';
import 'package:connectivity/connectivity.dart';
import 'package:wifi_connection/WifiInfo.dart';
import 'package:wifi_connection/WifiConnection.dart';

import '../../app_networking.dart';

class SpeedTestService {
  SpeedTestService();
  Connectivity _connectivity = Connectivity();
  final NetworkHelper _networkHelper = NetworkHelper();
  SpeedTestModel _speedTestModel;
  bool _isLoading = false;
  String _error;
  final Map<String, String> header = {
    "accept": "application/json",
  };


  Future<bool> fetchSignedUrls() async {
    _error = null;
    _isLoading = true;
    try {
      await getNewToken();
      // Get download & upload urls
      String _downloadResponse = await _networkHelper.authorizedFetch(
          "https://api-qa.ucsd.edu:8243/wifi_test/v1.0.0/generateDownloadUrl", header);
      String _uploadResponse = await _networkHelper.authorizedFetch(
          "https://api-qa.ucsd.edu:8243/wifi_test/v1.0.0/generateUploadUrl?name=temp.html", header);

      /// parse data
      await fetchNetworkDiagnostics().then((WifiInfo data) {
        _speedTestModel = speedTestModelFromJson(
            data, _downloadResponse, _uploadResponse, data != null);
      });
      _isLoading = false;
      return true;
    } catch (exception) {
      _error = exception.toString();
      _isLoading = false;
      return false;
    }
  }

  Future<WifiInfo> fetchNetworkDiagnostics() async {
    // Check connected to wifi
    if (await _connectivity.checkConnectivity() != ConnectivityResult.wifi) {
      return null;
    }
      bool isUCSDWIFI;
    // Check for UCSD wifi
     WifiInfo wiFiInfo = await WifiConnection.wifiInfo.then((value) {
       // if ( (!value.ssid.contains("UCSD-PROTECTED")) &&
       //      (!value.ssid.contains("UCSD-GUEST")) &&
       //      (!value.ssid.contains("ResNet"))) {
       //   print("Evaluated ucsd wifi to false");
       //   isUCSDWIFI = false;
       //   return null;
       // }
       isUCSDWIFI = true;
       return value;
     });

     if(!isUCSDWIFI){
       return null;
     }

    return wiFiInfo;
  }

  bool get isLoading => _isLoading;
  String get error => _error;
  SpeedTestModel get speedTestModel => _speedTestModel;

  Future<bool> getNewToken() async {
    final String tokenEndpoint = "https://api-qa.ucsd.edu:8243/token";
    final Map<String, String> tokenHeaders = {
      "content-type": 'application/x-www-form-urlencoded',
      "Authorization":
      "Basic djJlNEpYa0NJUHZ5akFWT0VRXzRqZmZUdDkwYTp2emNBZGFzZWpmaWZiUDc2VUJjNDNNVDExclVh"
    };
    try {
      var response = await _networkHelper.authorizedPost(
          tokenEndpoint, tokenHeaders, "grant_type=client_credentials");

      header["Authorization"] = "Bearer " + response["access_token"];

      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }
}
