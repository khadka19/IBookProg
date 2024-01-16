class UserMovementPostModel {
  int  UserId;
  String MovementDateTime;
  double Latitude;
  double Longitude;
  
  UserMovementPostModel({
    required this.UserId,
    required this.MovementDateTime,
    required this.Latitude,
    required this.Longitude,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'UserId ': UserId,
      'MovementDateTime': MovementDateTime,
      'Latitude':Latitude,
      'Longitude':Longitude,
    };
  }
}