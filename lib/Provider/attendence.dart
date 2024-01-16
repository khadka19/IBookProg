import 'package:flutter/material.dart';
import 'package:petrolpump/models/attendence_checkStatus_model.dart';

class AttendenceProvider extends ChangeNotifier {
    bool _checkIn = false;
  bool _checkOut = false;
double _currentLatitude = 0.0;
  double _currentLongitude = 0.0;

  bool get checkIn => _checkIn;
  bool get checkOut => _checkOut;
  double get currentLatitude => _currentLatitude;
  double get currentLongitude => _currentLongitude;

 AttendenceCheckStatus selectedAttendenceModel = AttendenceCheckStatus(
    checkIn: false,
    checkInTime: '',
    checkOut: false,
    checkOutTime: '',
  );

 void setCheckIn(bool value) {
    _checkIn = value;
    notifyListeners();
  }

  void setCheckOut(bool value) {
    _checkOut = value;
    notifyListeners();
  }
   void updateLocation(double latitude, double longitude) {
    _currentLatitude = latitude;
    _currentLongitude = longitude;
    notifyListeners();
  }
}
 

