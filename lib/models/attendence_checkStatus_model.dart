// ignore: file_names
import 'dart:convert';
SelectAttendenceCheckStatus selectAttendenceCheckStatusFromJson(String str) => SelectAttendenceCheckStatus.fromJson(json.decode(str));

class SelectAttendenceCheckStatus {
    bool success;
    String message;
    AttendenceCheckStatus data;

    SelectAttendenceCheckStatus({
        required this.success,
        required this.message,
        required this.data,
    });

    factory SelectAttendenceCheckStatus.fromJson(Map<String, dynamic> json) => SelectAttendenceCheckStatus(
        success: json["success"],
        message: json["message"],
        data: AttendenceCheckStatus.fromJson(json["data"]),
    );

    // Map<String, dynamic> toJson() => {
    //     "success": success,
    //     "message": message,
    //     "data": data.toJson(),
    // };
}

class AttendenceCheckStatus {
    bool checkIn;
    bool checkOut;
    String checkInTime;
    String checkOutTime;

    AttendenceCheckStatus({
        required this.checkIn,
        required this.checkOut,
        required this.checkInTime,
        required this.checkOutTime,
    });

    factory AttendenceCheckStatus.fromJson(Map<String, dynamic> json) => AttendenceCheckStatus(
        checkIn: json["checkIn"],
        checkOut: json["checkOut"],
        checkInTime: json["checkInTime"],
        checkOutTime: json["checkOutTime"],
    );

    Map<String, dynamic> toJson() => {
        "checkIn": checkIn,
        "checkOut": checkOut,
        "checkInTime": checkInTime,
        "checkOutTime": checkOutTime,
    };
}
