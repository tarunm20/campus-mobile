import 'package:campus_mobile_experimental/core/models/academic_term_model.dart';
import 'package:campus_mobile_experimental/core/models/class_schedule_model.dart';
import 'package:campus_mobile_experimental/core/models/student_id_barcode_model.dart';
import 'package:campus_mobile_experimental/core/models/student_id_name_model.dart';
import 'package:campus_mobile_experimental/core/models/student_id_photo_model.dart';
import 'package:campus_mobile_experimental/core/models/student_id_profile_model.dart';
import 'package:campus_mobile_experimental/core/services/networking.dart';
import 'package:flutter/cupertino.dart';

class StudentIdService {
  final String MY_STUDENT_PROFILE_API_URL = 'https://api.ucsd.edu:8243/student/my/v1';
  final String MY_STUDENT_CONTACT_API_URL = 'https://api.ucsd.edu:8243/student/my/student_contact_info/v1';

  bool _isLoading = false;
  DateTime _lastUpdated;
  String _error;
  StudentIdBarcodeModel _studentIdBarcodeModel = StudentIdBarcodeModel();
  StudentIdNameModel _studentIdNameModel = StudentIdNameModel();
  StudentIdPhotoModel _studentIdPhotoModel = StudentIdPhotoModel();
  StudentIdProfileModel _studentIdProfileModel = StudentIdProfileModel();

  final NetworkHelper _networkHelper = NetworkHelper();

  Future<bool> fetchStudentIdBarcode(Map<String, String> headers, String term) async {
    _error = null;
    _isLoading = true;
    try {
      /// fetch data
      String _response = await _networkHelper.authorizedFetch(
          MY_STUDENT_CONTACT_API_URL + '/barcode',
          headers
      );

      /// parse data
      _studentIdBarcodeModel = studentIdBarcodeModelFromJson(_response);
      _isLoading = false;
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      return false;
    }
  }

  Future<bool> fetchStudentIdName(Map<String, String> headers, String term) async {
    _error = null;
    _isLoading = true;
    try {
      /// fetch data
      String _response = await _networkHelper.authorizedFetch(
          MY_STUDENT_CONTACT_API_URL + '/display_name',
          headers
      );

      /// parse data
      _studentIdNameModel = studentIdNameModelFromJson(_response);
      _isLoading = false;
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      return false;
    }
  }

  Future<bool> fetchStudentIdPhoto(Map<String, String> headers, String term) async {
    _error = null;
    _isLoading = true;
    try {
      /// fetch data
      String _response = await _networkHelper.authorizedFetch(
          MY_STUDENT_CONTACT_API_URL + '/photo',
          headers
      );

      /// parse data
      _studentIdPhotoModel = studentIdPhotoModelFromJson(_response);
      _isLoading = false;
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      return false;
    }
  }

  Future<bool> fetchStudentIdProfile(Map<String, String> headers, String term) async {
    _error = null;
    _isLoading = true;
    try {
      /// fetch data
      String _response = await _networkHelper.authorizedFetch(
          MY_STUDENT_PROFILE_API_URL + '/photo',
          headers
      );

      /// parse data
      _studentIdPhotoModel = studentIdPhotoModelFromJson(_response);
      _isLoading = false;
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      return false;
    }
  }

  String get error => _error;
  StudentIdBarcodeModel get studentIdBarcodeModel => _studentIdBarcodeModel;
  StudentIdNameModel get studentIdNameModel => _studentIdNameModel;
  StudentIdPhotoModel get studentIdPhotoModel => _studentIdPhotoModel;
  StudentIdProfileModel get studentIdProfileModel => _studentIdProfileModel;
  bool get isLoading => _isLoading;
  DateTime get lastUpdated => _lastUpdated;
}
