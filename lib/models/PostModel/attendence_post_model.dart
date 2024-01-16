class AttendencePostModel {
  int id;
  int  userId;
  String attendanceDateTime;
  String attendenceType;
  double latitude;
  double longitude;
  
  AttendencePostModel({
    required this.id,
    required this.userId,
    required this.attendanceDateTime,
    required this.attendenceType,
    required this.latitude,
    required this.longitude,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'UserId ': userId,
      'AttendanceDateTime': attendanceDateTime,
      'Latitude':latitude,
      'Longitude':longitude,
      'AttendanceType': attendenceType
    };
  }
}